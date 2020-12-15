require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe "Merchants API" do
  it "merchant can display its items" do
    DatabaseCleaner.start
    merchant = create(:merchant, :with_items, items: 3)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful
    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      item1 = item[:attributes]

      expect(item1).to have_key(:id)
      expect(item1[:id]).to be_an(Integer)

      expect(item1).to have_key(:name)
      expect(item1[:name]).to be_a(String)

      expect(item1).to have_key(:description)
      expect(item1[:description]).to be_a(String)

      expect(item1).to have_key(:unit_price)
      expect(item1[:unit_price]).to be_a(Float)

      expect(item1).to have_key(:merchant_id)
      expect(item1[:merchant_id]).to be_an(Integer)
    end
    DatabaseCleaner.clean
  end
end
