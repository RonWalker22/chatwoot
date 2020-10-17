class Api::V1::ClarificationPostsController < Api::V1::FeedbackBaseController
  include ActionView::Helpers::DateHelper

  skip_before_action :set_contact, only: [:show]
  before_action :set_feedback, only: [:create, :show]

  def show
    render json: { comments: format_posts }
  end

  def create
    find_feedback_contact || create_feedback_contact
    post = ClarificationPost.new(author: @feedback_contact,
                                 body: permitted_params['body'],
                                 clarification_thread: @feedback.clarification_thread)
    if post.save
      render json: {
        feedback_id: post.author.feedback_id,
        feedback_status: post.author.feedback.status,
        post: {
          body: post.body,
          author: post.author.contact.name,
          id: post.id,
          datetime: time_ago_in_words(post.created_at)
        }
      }
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:website_token, :identifier, :body, :clarification_thread_id, :feedback_id, :email, :supporter)
  end

  def set_feedback
    @feedback = Feedback.find(permitted_params['feedback_id'])
  end
end
