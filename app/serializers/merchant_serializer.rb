class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  has_many :items

  attribute :revenue do |object|
    object.total_revenue
  end
end
