class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  def total_revenue
    invoices = self.invoices
    .select("sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:transactions, :invoice_items)
    .where("invoices.status = 'shipped' AND transactions.result = 'success' AND invoices.merchant_id = '#{self.id}'")
    .group(:id)
    .order("revenue DESC")

    invoices.sum do |rev|
      rev.revenue
    end
  end
end
