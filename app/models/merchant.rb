class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  def total_revenue
    invoices = self.invoices
    .select("sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:transactions, :invoice_items)
    .where("invoices.merchant_id = '#{self.id}'")
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .group(:id)
    .order("revenue DESC")

    invoices.sum do |rev|
      rev.revenue
    end
  end

  def self.total_revenue(limit)
    self.select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:transactions, :invoice_items)
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .group(:id)
    .order("revenue DESC")
    .limit(limit)
  end
end
