module Api::V1::FeedbacksHelper
  def format_posts(posts)
    posts.map do |post|
      { body: post.body,
        user: post.author_name,
        id: post.id,
        datetime: time_ago_in_words(post.created_at) }
    end
  end
end
