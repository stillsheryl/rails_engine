require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants", type: :request do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)
    merchants = json[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
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
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

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
  end

  it "can create a new merchant" do
    merchant_params = {
      name: "Bill's Barbour Shop"
      }
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/merchants', headers: headers, params: JSON.generate(
      merchant_params)
    created_merchant = Merchant.last

    expect(created_merchant.name).to eq(merchant_params[:name])

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

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
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Sally's Donuts" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)
    updated_merchant = Merchant.find_by(id: id)

    expect(response).to be_successful

    expect(updated_merchant.name).to eq(merchant_params[:name])
    expect(updated_merchant.name).to_not eq(previous_name)

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]

    expect(response).to be_successful

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
  end

  it "can delete a merchant" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
