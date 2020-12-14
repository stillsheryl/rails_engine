require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe "Items API" do
  it "sends a list of items", type: :request do
    DatabaseCleaner.start
    create_list(:item, 3)

    get '/api/v1/items'

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
      expect(item_data[:merchant_id]).to be_an(Integer)
    end
    DatabaseCleaner.clean
  end

  it "can get one item by its id", type: :request do
    DatabaseCleaner.start
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)
    item = json[:data]

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
    expect(item_data[:merchant_id]).to be_an(Integer)

    DatabaseCleaner.clean
  end

  it "can create a new item", type: :request do
    DatabaseCleaner.start
    merchant_id = create(:merchant).id
    item_params = {
      name: "Shoelaces",
      description: "Helps keep your shoes on",
      unit_price: 4.55,
      merchant_id: merchant_id
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item_params)
    created_item = Item.last

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    json = JSON.parse(response.body, symbolize_names: true)
    item = json[:data]

    expect(response).to be_successful

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
    expect(item_data[:merchant_id]).to be_an(Integer)

    DatabaseCleaner.clean
  end
end
