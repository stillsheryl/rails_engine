class RevenueFacade

  def self.merchant_total_revenue(merchant_id)
    revenue = Merchant.find(merchant_id).total_revenue
    Revenue.new(revenue)
  end

end
