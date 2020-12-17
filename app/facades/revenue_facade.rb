class RevenueFacade

  def self.merchant_total_revenue(merchant_id)
    revenue = Merchant.find(merchant_id).total_revenue
    Revenue.new(revenue)
  end

  def self.total_revenue(quantity)
    revenue = Merchant.total_revenue(quantity)
    @merchants = revenue.map do |merchant|
      Merchant.new({
        name: merchant.name,
        id: merchant.id})
    end
  end

end
