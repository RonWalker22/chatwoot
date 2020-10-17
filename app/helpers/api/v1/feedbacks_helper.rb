module Api::V1::FeedbacksHelper
  def format_posts(posts)
    posts.map do |post|
      if post.author_type == 'FeedbackContact'
        name = post.author.contact.name
      else
        user = post.author.user
        name = user.display_name.presence ? user.name : user.display_name
      end
      { body: post.body,
        author: name,
        id: post.id,
        datetime: time_ago_in_words(post.created_at) }
    end
  end
end
