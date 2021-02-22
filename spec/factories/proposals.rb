FactoryBot.define do
  factory :proposal do
    details { 'test data' }
    feedback
    user
    account
  end
end
