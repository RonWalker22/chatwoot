FactoryBot.define do
  factory :pro_con do
    body { 'test data' }
    proposal
    user
    account
  end
end
