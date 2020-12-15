require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe "Items API", type: :request do
  it "item can display its merchant" do
    DatabaseCleaner.start
    created_merchant = create(:merchant, :with_items, items: 1)
    item = Item.last

    get "/api/v1/items/#{item.id}/merchants"

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

    expect(merchant[:attributes][:id]).to eq(created_merchant.id)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to be_a(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)

    merchant_data = merchant[:attributes]

    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id]).to be_a(Integer)

    expect(merchant_data).to have_key(:name)
    expect(merchant_data[:name]).to be_a(String)

    DatabaseCleaner.clean
  end
end
