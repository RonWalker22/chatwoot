FactoryBot.define do
  factory :feedback do
    title { 'test data' }
    inbox
    account
    user
  end
end
