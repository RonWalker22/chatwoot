json.array! @feedbacks do |feedback|
  json.id feedback.id
  json.title feedback.title
  json.proposals feedback.proposals.where(primary: true)
  json.posts format_posts(
    feedback.clarification_posts.includes(:user).order(:created_at)
  ) || []
  json.requester feedback.requester_name
  json.supported @my_feedback_ids.include?(feedback.id)
end
