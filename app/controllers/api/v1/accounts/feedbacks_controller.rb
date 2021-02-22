class Api::V1::Accounts::FeedbacksController < Api::V1::Accounts::BaseController
  before_action :set_feedback, only: [:show]
  before_action :check_authorization, except: [:index, :show]

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
      @feedback = Current.account.feedbacks.new(feedback_params)
      @feedback.user = Current.user
      @feedback.save!
      FeedbackUser.create user: Current.user, feedback: @feedback
    end
  end

  def bulk_update
    @feedbacks = Current.account.feedbacks.find(params[:ids])
    @feedbacks.each do |feedback|
      feedback.update(feedback_params)
    end
  end

  def bulk_destroy
    feedbacks = Current.account.feedbacks.destroy_by(id: params[:ids])
    render json: { ids: feedbacks.pluck(:id) }
  end

  private

  def set_feedback
    @feedback = Current.account.feedbacks.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :status, :kind, :inbox_id)
  end

  def permitted_params
    params.permit(:solution, :support_level, :problem, :details)
  end

  def feedbacks
    Current.account.feedbacks.includes(:feedback_users)
  end

  def format_proposals
    @proposals = @feedback.proposals.includes(
      :clarification_thread,
      :user,
      pro_cons: [:user]
    ).order(:created_at)
    @proposals = @proposals.map do |proposal|
      proposal.as_json.merge(proposal.extra_details)
    end
  end

  def set_posts
    @posts = @feedback.clarification_posts.includes(:user).order(:created_at)
    @posts = formate_posts(@posts)
  end

  def formate_posts(posts)
    posts.map do |post|
      { body: post.body,
        user: post.author_name,
        id: post.id,
        date: post.created_at.strftime('%b %d %Y'),
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

  def check_authorization
    authorize(@feedback || Feedback)
  end
end