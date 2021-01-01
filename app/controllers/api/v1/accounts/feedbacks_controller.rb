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
    @feedback = Feedback.new(feedback_params)
    @feedback.account = Current.account

    if @feedback.save
      render :create
    else
      render json: feedback.errors, status: :unprocessable_entity
    end
  end

  def update
    @feedback.update!(feedback_params)
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
    @proposals = @feedback.proposals.includes(
      :clarification_thread,
      proposer: [:feedback_contact, :feedback_user, :user, :contact]
    ).order(:created_at)
    @proposals = @proposals.map do |proposal|
      proposal.as_json.merge(proposal.extra_details)
    end
  end

  def set_posts
    @posts = @feedback.clarification_posts.includes(author: [:feedback_contact, :feedback_user, :user, :contact]).order(:created_at)
    @posts = formate_posts(@posts)
  end

  def formate_posts(posts)
    posts.map do |post|
      if post.author_type == 'FeedbackContact'
        name = post.author.contact.name
      else
        user = post.author.user
        name = user.display_name.presence ? user.display_name : user.name
      end
      { body: post.body,
        author: name,
        id: post.id,
        date: post.created_at.to_date,
        thread: post.clarification_thread_id }
    end
  end

  def set_feedback_user
    @feedback_user = FeedbackUser.find_by(
      feedback: @feedback,
      user: Current.user
    )
    @feedback_user || create_feedback_user
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
end
