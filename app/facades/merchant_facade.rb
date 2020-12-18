class MerchantFacade
  def self.merchants_with_most_revenue(quantity)
    merchants = Merchant.most_revenue(quantity)
    merchants.map do |merchant|
      MerchantObject.new(merchant)
    end
  end

  def self.merchants_with_most_items_sold(quantity)
    merchants = Merchant.most_items_sold(quantity.to_i)
    merchants.map do |merchant|
      MerchantObject.new(merchant)
    end
  end
end
