require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe MerchantObject do
  it "exists" do
    merchant = create(:merchant, :with_items, items:3)

    merchant_object = MerchantObject.new(merchant)

    expect(merchant_object).to be_an_instance_of(MerchantObject)
    expect(merchant_object.id).to eq(merchant.id)
    expect(merchant_object.name).to eq(merchant.name)
  end
end
