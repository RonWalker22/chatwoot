class Api::V1::Accounts::FeedbacksController < Api::V1::Accounts::BaseController
  before_action :set_feedback, only: [:update, :show]

  def index
    @feedbacks = feedbacks
  end

  def show
    format_solutions
    format_problems
    set_posts
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
    render json: @feedback
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

  def format_solutions
    @solutions = @feedback.solutions.includes(:problems, proposer: [:feedback_contact, :feedback_user, :user, :contact]).order(:created_at)
    @solutions = @solutions.map do |solution|
      extra_details = { proposer: solution.proposer_name,
                        problems: solution.problems.ids }
      solution.as_json.merge(extra_details)
    end
  end

  def format_problems
    @problems = @feedback.problems.includes(:solutions, proposer: [:feedback_contact, :feedback_user, :user, :contact]).order(:created_at)
    @problems = @problems.map do |problem|
      extra_details = { proposer: problem.proposer_name,
                        solutions: problem.solutions.ids }
      problem.as_json.merge(extra_details)
    end
  end

  def set_posts
    @posts = @feedback.clarification_posts.includes(author: [:feedback_contact, :feedback_user, :user, :contact]).order(:created_at).map do |post|
      if post.author_type == 'FeedbackContact'
        name = post.author.contact.name
      else
        user = post.author.user
        name = user.display_name.presence ? user.name : user.display_name
      end
      { body: post.body,
        author: name,
        id: post.id,
        date: post.created_at.to_date }
    end
  end

  def create_feedback_user
    @feedback_user = FeedbackUser.create user: Current.user,
                                         feedback: @feedback
  end

  def create_proposals
    if permitted_params['problem']
      Problem.create! proposer: @feedback_user,
                      feedback: @feedback_user.feedback,
                      details: permitted_params['problem'],
                      primary: true
    end

    return unless permitted_params['solution']

    Solution.create! proposer: @feedback_user,
                     feedback: @feedback_user.feedback,
                     details: permitted_params['solution'],
                     primary: true
  end
end
