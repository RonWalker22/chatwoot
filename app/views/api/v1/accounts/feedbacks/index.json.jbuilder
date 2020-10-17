json.array! @feedbacks do |feedback|
  json.id feedback.id
  json.title feedback.title
  json.kind feedback.kind
  json.account feedback.account_id
  json.posts []
  json.status feedback.status
end
