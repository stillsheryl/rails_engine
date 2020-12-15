require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe "Merchants API", type: :request do
  it "item can display merchant results from a keyword search" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"keyword" => "Cookie"}

    get '/api/v1/items/find', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful

    expect(items.first[:attributes][:id]).to eq(item2.id).or(eq(item3.id))
    expect(items.second[:attributes][:id]).to eq(item3.id).or(eq(item2.id))

    item = items.first

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item).to have_key(:type)
    expect(item[:type]).to be_a(String)

    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)

    item_data = item[:attributes]

    expect(item_data).to have_key(:id)
    expect(item_data[:id]).to be_a(Integer)

    expect(item_data).to have_key(:name)
    expect(item_data[:name]).to be_a(String)

    DatabaseCleaner.clean
  end

  it "search is case insensitive" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"keyword" => "MUFFIN"}

    get '/api/v1/items/find', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful

    expect(items.first[:attributes][:id]).to eq(item1.id)

    item = items.first

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item).to have_key(:type)
    expect(item[:type]).to be_a(String)

    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)

    item_data = item[:attributes]

    expect(item_data).to have_key(:id)
    expect(item_data[:id]).to be_a(Integer)

    expect(item_data).to have_key(:name)
    expect(item_data[:name]).to be_a(String)

    DatabaseCleaner.clean
  end

  it "search can find results from partial match" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"keyword" => "choc"}

    get '/api/v1/items/find', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful

    expect(items.first[:attributes][:id]).to eq(item3.id)

    item = items.first

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item).to have_key(:type)
    expect(item[:type]).to be_a(String)

    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)

    item_data = item[:attributes]

    expect(item_data).to have_key(:id)
    expect(item_data[:id]).to be_a(Integer)

    expect(item_data).to have_key(:name)
    expect(item_data[:name]).to be_a(String)

    DatabaseCleaner.clean
  end
end
