class Api::V1::Accounts::FeedbacksController < Api::V1::Accounts::BaseController
  before_action :set_feedback, only: [:update, :show]

  def index
    @feedbacks = feedbacks
  end

  def show
    format_proposals
    set_posts
    set_feedback_user
    format_feedback_user
  end

  def create
    ActiveRecord::Base.transaction do
      @feedback = Feedback.new(feedback_params)
      @feedback.account = Current.account
      @feedback.save!
      create_feedback_user
      @feedback.requester = @feedback_user
      @feedback.save!
      create_proposals
    end

    render json:
                {
                  id: @feedback.id,
                  title: @feedback.title,
                  kind: @feedback.kind,
                  account: @feedback.account.id,
                  posts: [],
                  status: @feedback.status
                }
  end

  def update
    @feedback.update!(feedback_params)
    render json: {
      status: @feedback.status,
      title: @feedback.title,
      kind: @feedback.kind,
      id: @feedback.id
    }
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: e.record.errors.full_messages.join(', ')
    }, status: :unprocessable_entity
  end

  private

  def set_feedback
    @feedback = Current.account.feedbacks.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :status, :funding_goal, :kind, :inbox_id)
  end

  def permitted_params
    params.permit(:solution, :support_level, :problem, :details)
  end

  def feedbacks
    Current.account.feedbacks
  end

  def format_proposals
    @proposals = @feedback.proposals.includes(proposer: [:feedback_contact, :feedback_user, :user, :contact]).order(:created_at)
    @proposals = @proposals.map do |proposal|
      extra_details = { proposer: proposal.proposer_name }
      proposal.as_json.merge(extra_details)
    end
  end

  def set_posts
    @posts = @feedback.clarification_posts.includes(author: [:feedback_contact, :feedback_user, :user, :contact]).order(:created_at).map do |post|
      if post.author_type == 'FeedbackContact'
        name = post.author.contact.name
      else
        user = post.author.user
        name = user.display_name.presence ? user.display_name : user.name
      end
      { body: post.body,
        author: name,
        id: post.id,
        date: post.created_at.to_date }
    end
  end

  def set_feedback_user
    @feedback_user = FeedbackUser.find_by(
      feedback: @feedback,
      user: Current.user
    )
  end

  def format_feedback_user
    return unless @feedback_user

    @evaluation = @feedback_user.evaluation
    @feedback_user_id = @feedback_user.id
  end

  def create_feedback_user
    @feedback_user = FeedbackUser.create user: Current.user,
                                         feedback: @feedback
  end

  def create_proposals
    if permitted_params['problem']
      Proposal.create! proposer: @feedback_user,
                       feedback: @feedback_user.feedback,
                       details: permitted_params['problem'],
                       primary: true,
                       solution: false
    end

    return unless permitted_params['solution']

    Proposal.create! proposer: @feedback_user,
                     feedback: @feedback_user.feedback,
                     details: permitted_params['solution'],
                     primary: true,
                     solution: true
  end
end
