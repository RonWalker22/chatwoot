json.array! @feedbacks do |feedback|
  json.id feedback.display_id
  json.title feedback.title
  json.kind feedback.kind
  json.account feedback.account_id
  json.posts []
  json.status feedback.status
  json.evaluation feedback_user_evaluation(feedback.feedback_users)
end
