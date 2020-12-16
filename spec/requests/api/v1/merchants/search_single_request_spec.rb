require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe "Merchants API", type: :request do
  it "search can display only one merchant result from a keyword search" do
    DatabaseCleaner.start
    merchant1 = Merchant.create!(name: "Molly's Muffins")
    merchant2 = Merchant.create!(name: "Ted's Televisions")
    merchant3 = Merchant.create!(name: "Koepp LLC")
    merchant4 = Merchant.create!(name: "GetIt LLC")
    merchant5 = Merchant.create!(name: "LoveLife LLC")

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"name" => "LLC"}

    get '/api/v1/merchants/find', headers: headers, params: params

    results = JSON.parse(response.body, symbolize_names: true)
    merchant = results[:data]

    expect(response).to be_successful

    expect(results.count).to eq(1)
    expect(merchant[:attributes][:id]).to eq(merchant3.id).or(eq(merchant4.id)).or(eq(merchant5.id))

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

  it "search is case insensitive" do
    DatabaseCleaner.start
    merchant1 = Merchant.create!(name: "Molly's Muffins")
    merchant2 = Merchant.create!(name: "Ted's Televisions")
    merchant3 = Merchant.create!(name: "Koepp LLC")

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"name" => "llc"}

    get '/api/v1/merchants/find', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

    expect(merchant[:attributes][:id]).to eq(merchant3.id)

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

  it "search can find results from partial match" do
    DatabaseCleaner.start
    merchant1 = Merchant.create!(name: "Molly's Muffins")
    merchant2 = Merchant.create!(name: "Ted's Televisions")
    merchant3 = Merchant.create!(name: "Koepp LLC")

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"name" => "tele"}

    get '/api/v1/merchants/find', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

    expect(merchant[:attributes][:id]).to eq(merchant2.id)

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

  it "search can find results from created_at date" do
    DatabaseCleaner.start
    merchant1 = Merchant.create!(name: "Molly's Muffins", created_at: "2012-03-27 14:54:00")
    merchant2 = Merchant.create!(name: "Ted's Televisions")
    merchant3 = Merchant.create!(name: "Koepp LLC")

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"created_at" => "2012-03-27 14:54:00"}

    get '/api/v1/merchants/find', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

    expect(merchant[:attributes][:id]).to eq(merchant1.id)

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

  it "search can find results from updated_at date" do
    DatabaseCleaner.start
    merchant1 = Merchant.create!(name: "Molly's Muffins", updated_at: "2012-03-27 14:54:00")
    merchant2 = Merchant.create!(name: "Ted's Televisions")
    merchant3 = Merchant.create!(name: "Koepp LLC")

    headers = {"CONTENT_TYPE" => "application/json"}
    params = {"updated_at" => "2012-03-27 14:54:00"}

    get '/api/v1/merchants/find', headers: headers, params: params

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

    expect(merchant[:attributes][:id]).to eq(merchant1.id)

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
