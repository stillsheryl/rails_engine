require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

describe Revenue do
  it "exists" do
    revenue = Revenue.new(1299.99)

    expect(revenue).to be_an_instance_of(Revenue)
    expect(revenue.id).to eq(nil)
    expect(revenue.revenue).to eq(1299.99)
  end
end
