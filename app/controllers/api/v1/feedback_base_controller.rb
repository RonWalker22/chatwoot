class Api::V1::FeedbackBaseController < Api::V1::Widget::BaseController
  private

  def create_feedback_contact
    support_level = permitted_params['support_level'] || 0
    supporter     = permitted_params['supporter']
    @feedback_contact = FeedbackContact.create contact_id: @contact.id,
                                               feedback_id: @feedback.id,
                                               support_level: support_level,
                                               supporter: supporter
  end

  def find_feedback_contact
    @feedback_contact = FeedbackContact.find_by contact_id: @contact.id,
                                                feedback_id: @feedback.id
  end
end
