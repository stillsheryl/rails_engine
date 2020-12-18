class RevenueFacade
  def self.merchant_total_revenue(merchant_id)
    merchant = Merchant.find(merchant_id).total_revenue
    Revenue.new(merchant.revenue)
  end

  def self.total_revenue_by_date(date_params)
    total = Merchant.revenue_by_date(date_params)
    Revenue.new(total.revenue)
  end
end
