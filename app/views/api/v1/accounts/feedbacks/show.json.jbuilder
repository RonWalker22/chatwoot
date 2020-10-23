json.proposals @proposals
json.posts @posts || []
json.id @feedback.id
json.title @feedback.title
json.requester @feedback.requester_name
json.account @feedback.account_id
json.kind @feedback.kind
json.status @feedback.status
json.evaluation @evaluation if @evaluation
json.feedback_user_id @feedback_user_id if @feedback_user_id
