class Api::V1::FeedbackContactsController < Api::V1::FeedbackBaseController
  before_action :set_web_widget
  before_action :set_contact, only: [:create]
  before_action :set_feedback, only: [:create]

  def create
    support_level = permitted_params['support_level']
    supporter = permitted_params['supporter']
    feedback_contact = FeedbackContact.new  contact_id: @contact.id,
                                            feedback_id: @feedback.id,
                                            support_level: support_level,
                                            supporter: supporter
    if feedback_contact.save
      render json: { id: feedback_contact.id,
                     feedback_status: feedback_contact.feedback.status,
                     feedback_id: feedback_contact.feedback.id,
                     support_level: feedback_contact.support_level }
    else
      render json: feedback_contact.errors, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:website_token, :identifier, :support_level, :feedback_id, :email, :supporter)
  end

  def set_feedback
    @feedback = Feedback.find(permitted_params['feedback_id'])
  end
end
