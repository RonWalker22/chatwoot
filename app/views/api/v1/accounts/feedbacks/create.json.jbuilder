json.id @feedback.display_id
json.title @feedback.title
json.kind @feedback.kind
json.account @feedback.account.id
json.posts []
json.status @feedback.status
json.evaluation @evaluation if @evaluation
