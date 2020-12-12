FactoryBot.define do
  factory :invoice_item do
    item
    invoice
    quantity { Faker::Number.within(range: 1..150) }
    unit_price { Faker::Commerce.price }
  end
end
