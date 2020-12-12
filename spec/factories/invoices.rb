FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { Faker::Subscription.status }
  end
end
