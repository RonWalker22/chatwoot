FactoryBot.define do
  factory :clarification_post do
    body { 'test data' }
    proposal
    account
    user
  end
end
