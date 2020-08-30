module Api::V1::FeedbacksHelper
  def format_posts(posts)
    posts.map do |post|
      { body: post.body,
        contact: post.feedback_contact.contact.name,
        id: post.id,
        datetime: time_ago_in_words(post.created_at) }
    end
  end
end
