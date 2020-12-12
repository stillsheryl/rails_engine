FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { Faker::Finance.credit_card }
    credit_card_expiration_date { Faker::Dessert.variety }
    result { Faker::Science.element }
  end
end
