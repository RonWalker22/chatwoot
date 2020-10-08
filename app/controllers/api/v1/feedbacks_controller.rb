class Api::V1::FeedbacksController < Api::V1::FeedbackBaseController
  before_action :set_feedback, only: [:show]

  def index
    @feedbacks = @web_widget.feedbacks.includes(
      :feedback_contacts,
      :clarification_posts,
      solutions: [:contact, :problems],
      problems: [:contact, :solutions]
    ).where(status: 'active')

    set_my_feedback_ids
  end

  def show
    format_solutions
    format_problems
    set_posts
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.requester = @contact
    @feedback.web_widget = @web_widget
    @feedback.account = @web_widget.account
    respond_to do |format|
      if @feedback.save
        create_feedback_contact
        create_proposals
        format.json { render json: { id: @feedback.id }, status: :created }
      else
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :organization_id, :status, :funding_goal)
  end

  def permitted_params
    params.permit(:website_token, :identifier, :solution, :support_level, :problem, :email, :details, :supporter)
  end

  def format_solutions
    @solutions = @feedback.solutions.includes(:contact, :problems).order(:created_at).map do |solution|
      { solution: solution,
        contact: solution.contact.name,
        problems: solution.problems.ids }
    end
  end

  def format_problems
    @problems = @feedback.problems.includes(:contact, :solutions).order(:created_at).map do |problem|
      { problem: problem,
        contact: problem.contact.name,
        solutions: problem.solutions.ids }
    end
  end

  def create_proposals
    if permitted_params['problem']
      Problem.create feedback_contact_id: @feedback_contact.id,
                     details: permitted_params['problem']
    end

    return unless permitted_params['solution']

    Solution.create feedback_contact_id: @feedback_contact.id,
                    details: permitted_params['solution']
  end

  def set_posts
    @post = @feedback.clarification_posts.order(:created_at).map do |post|
      { body: post.body,
        contact: post.feedback_contact.contact.name,
        id: post.id,
        datetime: post.created_at }
    end
  end

  def set_my_feedback_ids
    @my_feedback_ids = []
    @feedbacks.map do |feedback|
      ids = feedback.feedback_contacts.where(supporter: true).pluck(:contact_id)
      @my_feedback_ids.push(feedback.id) if ids.include?(@contact.id)
    end
  end
end
