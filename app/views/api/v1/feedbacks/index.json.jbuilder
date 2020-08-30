json.array! @feedbacks do |feedback|
  json.id feedback.id
  json.title feedback.title
  json.solutions feedback.solutions
  json.problems feedback.problems
  json.posts format_posts(feedback.clarification_posts) || []
  json.contact feedback.requester.name
  json.supported @my_feedback_ids.include?(feedback.id)
end
