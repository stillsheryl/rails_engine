class Transaction < ApplicationRecord
  belongs_to :invoice
  has_one :merchant, through: :invoice, source: :merchant

  scope :successful, -> { where(result: "success") }
end
