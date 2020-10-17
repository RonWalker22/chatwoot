class Api::V1::FeedbacksController < Api::V1::FeedbackBaseController
  def index
    @feedbacks = inbox.feedbacks.includes(
      :feedback_contacts,
      :clarification_posts,
      solutions: [:proposer, :problems],
      problems: [:proposer, :solutions]
    ).where(status: 'active')

    set_my_feedback_ids
  end

  def create
    ActiveRecord::Base.transaction do
      @feedback = Feedback.new(feedback_params)
      @feedback.inbox = inbox
      @feedback.account = @web_widget.account
      @feedback.save!
      create_feedback_contact
      @feedback.requester = @feedback_contact
      @feedback.save!
      create_proposals
    end

    render json:
                {
                  id: @feedback.id,
                  title: @feedback.title,
                  kind: @feedback.kind,
                  account: @feedback.account,
                  posts: []
                }
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :organization_id, :status, :funding_goal, :kind)
  end

  def permitted_params
    params.permit(:website_token, :identifier, :solution, :support_level, :problem, :email, :details, :supporter)
  end

  def create_proposals
    if permitted_params['problem']
      Problem.create! proposer: @feedback_contact,
                      feedback: @feedback_contact.feedback,
                      details: permitted_params['problem'],
                      primary: true
    end

    return unless permitted_params['solution']

    Solution.create! proposer: @feedback_contact,
                     feedback: @feedback_contact.feedback,
                     details: permitted_params['solution'],
                     primary: true
  end

  # TODO: create feedback_supporter model
  def set_my_feedback_ids
    @my_feedback_ids = []
    @feedbacks.map do |feedback|
      ids = feedback.feedback_contacts.where(supporter: true).pluck(:contact_id)
      @my_feedback_ids.push(feedback.id) if ids.include?(@contact.id)
    end
  end

  def inbox
    @inbox ||= ::Inbox.find_by(id: auth_token_params[:inbox_id])
  end
end
