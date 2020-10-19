class Api::V1::Accounts::FeedbackUsersController < Api::V1::Accounts::BaseController
  before_action :set_feedback_user, only: [:update]
  before_action :check_authorization, except: [:create]

  def create
    feedback_user = FeedbackUser.new(
      feedback_id: params[:feedback_id],
      user: Current.user
    )
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
      id: @feedback_user.id
    }
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: e.record.errors.full_messages.join(', ')
    }, status: :unprocessable_entity
  end

  private

  def feedback_user_params
    params.require('feedback_user').permit(:evaluation, :feedback_user_id, :feedback_id)
  end

  def set_feedback_user
    @feedback_user = FeedbackUser.find(params[:id]) || create_feedback_user
  end

  def create_feedback_user
    return unless params[:feedback_id]

    FeedbackUser.create user: Current.user,
                        feedback: FeedbackUser.find(params[:feedback_id])
  end

  def check_authorization
    authorize(@feedback_user)
  end
end
