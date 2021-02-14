json.array! @feedbacks do |feedback|
  json.partial! 'api/v1/accounts/feedbacks/update', feedback: feedback
end
