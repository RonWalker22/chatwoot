class Api::V1::Accounts::FeedbackUsersController < Api::V1::Accounts::BaseController
  before_action :set_feedback
  before_action :set_feedback_user, only: [:update]
  before_action :check_authorization

  def create
    feedback_user = FeedbackUser.new feedback: @feedback, user: Current.user
    if feedback_user.save
      render json: { id: feedback_user.id }
    else
      render json: feedback_user.errors, status: :unprocessable_entity
    end
  end

  def update
    @feedback_user.update!(feedback_user_params)
    render json: {
      evaluation: @feedback_user.evaluation,
      feedback_id: @feedback_user.feedback.id,
      feedback_user_id: @feedback_user.id,
      id: @feedback_user.feedback_id
    }
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: e.record.errors.full_messages.join(', ')
    }, status: :unprocessable_entity
  end

  private

  def feedback_user_params
    params.require('feedback_user').permit(:evaluation)
  end

  def set_feedback
    @feedback = Current.account.feedbacks.find(params[:feedback_id])
  end

  def set_feedback_user
    @feedback_user = FeedbackUser.find_by(feedback: @feedback,
                                          id: params[:id]) ||
                     create_feedback_user
  end

  def create_feedback_user
    return unless @feedback

    FeedbackUser.create user: Current.user,
                        feedback: @feedback
  end

  def check_authorization
    authorize(@feedback_user || FeedbackUser)
  end
end
