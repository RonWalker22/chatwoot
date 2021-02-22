FactoryBot.define do
  factory :clarification_post do
    body { 'test data' }
    clarification_thread { author.feedback.clarification_thread }
    account
    user
  end
end
