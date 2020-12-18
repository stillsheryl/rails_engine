class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  def total_revenue
    Invoice
    .joins(:transactions, :invoice_items)
    .select("sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .where("merchant_id = ?", self.id)
    .reorder("")
    .first
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

  def self.most_items_sold(limit)
    self.select("merchants.*, sum(invoice_items.quantity) AS total_sold")
    .joins(invoices: [:transactions, :invoice_items])
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .group(:id)
    .order("total_sold DESC")
    .limit(limit)
  end
end
