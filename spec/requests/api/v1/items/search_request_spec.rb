require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe "Items API", type: :request do
  it "can display item results from a keyword search" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"name" => "Cookie"}

    get '/api/v1/items/find_all', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful

    expect(items.count).to eq(2)
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

    expect(item_data).to have_key(:description)
    expect(item_data[:description]).to be_a(String)

    expect(item_data).to have_key(:unit_price)
    expect(item_data[:unit_price]).to be_a(Float)

    expect(item_data).to have_key(:merchant_id)
    expect(item_data[:merchant_id]).to be_a(Integer)

    DatabaseCleaner.clean
  end

  it "search is case insensitive" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"name" => "MUFFIN"}

    get '/api/v1/items/find_all', headers: headers, params: params

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

    expect(item_data).to have_key(:description)
    expect(item_data[:description]).to be_a(String)

    expect(item_data).to have_key(:unit_price)
    expect(item_data[:unit_price]).to be_a(Float)

    expect(item_data).to have_key(:merchant_id)
    expect(item_data[:merchant_id]).to be_a(Integer)

    DatabaseCleaner.clean
  end

  it "search can find results from partial match" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"name" => "choc"}

    get '/api/v1/items/find_all', headers: headers, params: params

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

    expect(item_data).to have_key(:description)
    expect(item_data[:description]).to be_a(String)

    expect(item_data).to have_key(:unit_price)
    expect(item_data[:unit_price]).to be_a(Float)

    expect(item_data).to have_key(:merchant_id)
    expect(item_data[:merchant_id]).to be_a(Integer)

    DatabaseCleaner.clean
  end

  it "can search by a description" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)
    item4 = merchant.items.create!(name: "Peanut Butter Cookie", description: "peanut-buttery goodness", unit_price: 3.99)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"description" => "goodness"}

    get '/api/v1/items/find_all', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful
    expect(items.count).to eq(2)
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

    expect(item_data).to have_key(:description)
    expect(item_data[:description]).to be_a(String)

    expect(item_data).to have_key(:unit_price)
    expect(item_data[:unit_price]).to be_a(Float)

    expect(item_data).to have_key(:merchant_id)
    expect(item_data[:merchant_id]).to be_a(Integer)

    DatabaseCleaner.clean
  end

  it "can search by a unit_price" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)
    item4 = merchant.items.create!(name: "Peanut Butter Cookie", description: "peanut-buttery goodness", unit_price: 3.99)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"unit_price" => "3.99"}

    get '/api/v1/items/find_all', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful
    expect(items.count).to eq(2)
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

    expect(item_data).to have_key(:description)
    expect(item_data[:description]).to be_a(String)

    expect(item_data).to have_key(:unit_price)
    expect(item_data[:unit_price]).to be_a(Float)

    expect(item_data).to have_key(:merchant_id)
    expect(item_data[:merchant_id]).to be_a(Integer)

    DatabaseCleaner.clean
  end

  it "can search by a merchant_id" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99)
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99)
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)
    item4 = merchant.items.create!(name: "Peanut Butter Cookie", description: "peanut-buttery goodness", unit_price: 3.99)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"merchant_id" => merchant.id.to_s}

    get '/api/v1/items/find_all', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful
    expect(items.count).to eq(4)
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

    expect(item_data).to have_key(:description)
    expect(item_data[:description]).to be_a(String)

    expect(item_data).to have_key(:unit_price)
    expect(item_data[:unit_price]).to be_a(Float)

    expect(item_data).to have_key(:merchant_id)
    expect(item_data[:merchant_id]).to be_a(Integer)

    DatabaseCleaner.clean
  end

  it "can search by created_at date" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99, created_at: "2012-03-27 14:54:00")
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99, created_at: "2012-03-27 14:54:00")
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)
    item4 = merchant.items.create!(name: "Peanut Butter Cookie", description: "peanut-buttery goodness", unit_price: 3.99)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"created_at" => "2012-03-27 14:54:00"}

    get '/api/v1/items/find_all', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful
    expect(items.count).to eq(2)
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

    expect(item_data).to have_key(:description)
    expect(item_data[:description]).to be_a(String)

    expect(item_data).to have_key(:unit_price)
    expect(item_data[:unit_price]).to be_a(Float)

    expect(item_data).to have_key(:merchant_id)
    expect(item_data[:merchant_id]).to be_a(Integer)

    DatabaseCleaner.clean
  end

  it "can search by updated_at date" do
    DatabaseCleaner.start
    merchant = Merchant.create!(name: "Molly's Muffins")

    item1 = merchant.items.create!(name: "Blueberry Muffin", description: "delicious muffin", unit_price: 3.99, updated_at: "2012-03-27 14:54:00")
    item2 = merchant.items.create!(name: "Cookie", description: "sweet and fun", unit_price: 2.99, updated_at: "2012-03-27 14:54:00")
    item3 = merchant.items.create!(name: "Chocolate Chip Cookie", description: "chocolatey goodness", unit_price: 3.50)
    item4 = merchant.items.create!(name: "Peanut Butter Cookie", description: "peanut-buttery goodness", unit_price: 3.99)

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"updated_at" => "2012-03-27 14:54:00"}

    get '/api/v1/items/find_all', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    items = json[:data]

    expect(response).to be_successful
    expect(items.count).to eq(2)
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

    expect(item_data).to have_key(:description)
    expect(item_data[:description]).to be_a(String)

    expect(item_data).to have_key(:unit_price)
    expect(item_data[:unit_price]).to be_a(Float)

    expect(item_data).to have_key(:merchant_id)
    expect(item_data[:merchant_id]).to be_a(Integer)
    
    DatabaseCleaner.clean
  end
end
