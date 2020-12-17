class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  def total_revenue
    self.invoices
    .select("sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:transactions, :invoice_items)
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .group(:merchant_id)
  end

  def self.most_revenue(limit)
    self.select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(invoices: [:transactions, :invoice_items])
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .group(:id)
    .order("revenue DESC")
    .limit(limit)
  end
end


# self.invoices.select("sum(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(:transactions, :invoice_items).where("invoices.merchant_id = '#{self.id}'").merge(Transaction.successful).merge(Invoice.shipped).group(:id).order("revenue DESC")

# self.invoices.select("sum(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(:transactions, :invoice_items).merge(Transaction.successful).merge(Invoice.shipped).group(:id)
#
# SELECT sum(invoice_items.quantity * invoice_items.unit_price) AS revenue
# FROM "invoices"
# INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id"
# INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id"
# WHERE "invoices"."merchant_id" = 9186 AND "transactions"."result" = 'success' AND "invoices"."status" = 'shipped'
# GROUP BY "invoices"."merchant_id"
#
#
# # invoices = self.invoices
# # .select("sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
# # .joins(:transactions, :invoice_items)
# # .where("invoices.merchant_id = '#{self.id}'")
# # .merge(Transaction.successful)
# # .merge(Invoice.shipped)
# # .group(:id)
# # .order("revenue DESC")
# #
# invoices.sum do |rev|
#   rev.revenue
# end
