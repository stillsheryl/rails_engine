require 'rails_helper'

describe MerchantFacade do
  before :each do
    @merchant1 = Merchant.create!(name: "Ken's Bike Shop")
    @merchant2 = Merchant.create!(name: "Kip's Bookstore")
    @merchant3 = Merchant.create!(name: "Andy's Jewels")
    @customer1 = Customer.create!(first_name: "Bilbo", last_name: "Baggins")
    @customer2 = Customer.create!(first_name: "Sally", last_name: "Peach")
    @customer3 = Customer.create!(first_name: "Harry", last_name: "Potter")
    @laces = @merchant1.items.create!(name: "Shoe@laces",
      description: "Helps keep your shoes on",
      unit_price: 4.55)
    @tire = @merchant1.items.create!(name: "Tire",
      description: "It's round",
      unit_price: 12.99)
    @bike = @merchant1.items.create!(name: "Bike",
      description: "Ride around on it",
      unit_price: 799.99)
    @book = @merchant2.items.create!(name: "Book",
      description: "Learn all the things",
      unit_price: 9.99)
    @magazine = @merchant2.items.create!(name: "Magazine",
      description: "All the gossip",
      unit_price: 5.00)
    @ring = @merchant3.items.create!(name: "Diamond Ring",
      description: "Frosting for your finger",
      unit_price: 5000.00)
    @invoice1 = @merchant1.invoices.create!(customer_id: @customer1.id, status: "shipped", created_at: "2012-03-14 13:57:45")
    @invoice2 = @merchant1.invoices.create!(customer_id: @customer2.id, status: "shipped", created_at: "2012-03-09 13:57:45")
    @invoice3 = @merchant1.invoices.create!(customer_id: @customer3.id, status: "shipped", created_at: "2012-03-27 01:57:45")
    @invoice4 = @merchant1.invoices.create!(customer_id: @customer3.id, status: "not shipped")
    @invoice5 = @merchant2.invoices.create!(customer_id: @customer2.id, status: "shipped")
    @invoice6 = @merchant2.invoices.create!(customer_id: @customer3.id, status: "shipped")
    @invoice7 = @merchant3.invoices.create!(customer_id: @customer1.id, status: "shipped")
    InvoiceItem.create!(item_id: @tire.id, invoice_id: @invoice1.id, quantity: 2, unit_price: 12.99)
    InvoiceItem.create!(item_id: @laces.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 4.55)
    InvoiceItem.create!(item_id: @bike.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 799.99)
    InvoiceItem.create!(item_id: @bike.id, invoice_id: @invoice3.id, quantity: 1, unit_price: 799.99)
    InvoiceItem.create!(item_id: @bike.id, invoice_id: @invoice4.id, quantity: 1, unit_price: 799.99)
    InvoiceItem.create!(item_id: @book.id, invoice_id: @invoice5.id, quantity: 2, unit_price: 9.99)
    InvoiceItem.create!(item_id: @magazine.id, invoice_id: @invoice6.id, quantity: 1, unit_price: 5.00)
    InvoiceItem.create!(item_id: @ring.id, invoice_id: @invoice7.id, quantity: 1, unit_price: 5000.00)
    @invoice1.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    @invoice2.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "failed")
    @invoice2.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    @invoice3.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    @invoice4.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    @invoice5.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    @invoice6.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
    @invoice7.transactions.create!(credit_card_number: "1234-5678-9012-3456", credit_card_expiration_date: "12/24", result: "success")
  end

  it "returns merchants with most revenue" do
    merchant = MerchantFacade.merchants_with_most_revenue(2)

    expect(merchant.count).to eq(2)
    expect(merchant.first).to be_an_instance_of(MerchantObject)
    expect(merchant.first.id).to eq(@merchant3.id)
    expect(merchant.first.name).to eq(@merchant3.name)
  end

  it "returns merchants with most items sold" do
    merchant = MerchantFacade.merchants_with_most_items_sold(2)

    expect(merchant.count).to eq(2)
    expect(merchant.first).to be_an_instance_of(MerchantObject)
    expect(merchant.first.id).to eq(@merchant1.id)
    expect(merchant.first.name).to eq(@merchant1.name)
  end
end
