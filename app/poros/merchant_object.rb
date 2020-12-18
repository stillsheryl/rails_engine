class MerchantObject
  attr_reader :id, :name, :item_ids
  def initialize(merchant_data)
    @id = merchant_data[:id]
    @name = merchant_data[:name]
    @item_ids = merchant_data.items.map do |item|
      item.id
    end
  end
end
