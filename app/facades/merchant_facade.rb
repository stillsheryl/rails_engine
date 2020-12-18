class MerchantFacade
  def self.merchants_with_most_revenue(quantity)
    merchant = Merchant.most_revenue(quantity)
    merchant.map do |merchant|
      MerchantObject.new(merchant)
    end
  end
end
