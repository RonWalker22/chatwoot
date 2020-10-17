json.array! @feedbacks do |feedback|
  json.id feedback.id
  json.title feedback.title
  json.solutions feedback.solutions
  json.problems feedback.problems
  json.posts format_posts(
    feedback.clarification_posts.includes(
      author: [:contact, :user, :feedback_contact]
    ).order(:created_at)
  ) || []
  json.requester feedback.requester_name
  json.supported @my_feedback_ids.include?(feedback.id)
end
