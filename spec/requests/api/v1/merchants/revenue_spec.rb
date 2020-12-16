require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe "Merchants API", type: :request do
  it "item can display the merchant's total revenue" do
    DatabaseCleaner.start

    merchant = Merchant.create!(name: "Ken's Bike Shop")
    customer1 = Customer.create!(first_name: "Bilbo", last_name: "Baggins")
    customer2 = Customer.create!(first_name: "Sally", last_name: "Peach")
    customer3 = Customer.create!(first_name: "Harry", last_name: "Potter")
    laces = merchant.items.create!(name: "Shoelaces",
      description: "Helps keep your shoes on",
      unit_price: 4.55)
    tire = merchant.items.create!(name: "Tire",
      description: "It's round",
      unit_price: 12.99)
    bike = merchant.items.create!(name: "Bike",
      description: "Ride around on it",
      unit_price: 799.99)
    invoice1 = merchant.invoices.create!(customer_id: customer1.id, status: "shipped")
    invoice2 = merchant.invoices.create!(customer_id: customer2.id, status: "shipped")
    invoice3 = merchant.invoices.create!(customer_id: customer3.id, status: "shipped")
    invoice4 = merchant.invoices.create!(customer_id: customer3.id, status: "not shipped")
    InvoiceItem.create!(item_id: tire.id, invoice_id: invoice1.id, quantity: 1, unit_price: 12.99)
    InvoiceItem.create!(item_id: laces.id, invoice_id: invoice1.id, quantity: 1, unit_price: 4.55)
    InvoiceItem.create!(item_id: bike.id, invoice_id: invoice2.id, quantity: 1, unit_price: 799.99)
    InvoiceItem.create!(item_id: bike.id, invoice_id: invoice3.id, quantity: 1, unit_price: 799.99)
    InvoiceItem.create!(item_id: bike.id, invoice_id: invoice4.id, quantity: 1, unit_price: 799.99)
    invoice1.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    invoice2.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "failed")
    invoice2.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    invoice3.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    invoice4.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")

    headers = {"CONTENT_TYPE" => "application/json"}

    get "/api/v1/merchants/#{merchant.id}/revenue", headers: headers

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

    expect(merchant[:attributes][:revenue].to_f.round(2)).to eq(1617.52)

    DatabaseCleaner.clean
  end
end
