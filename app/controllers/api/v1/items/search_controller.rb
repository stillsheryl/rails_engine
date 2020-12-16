class Api::V1::Items::SearchController < ApplicationController
  def index
    if params["name"] != nil
      keyword = params["name"].downcase
      item_results = Item.where("LOWER(name) like ?", "%#{keyword}%")
    elsif params["description"] != nil
      keyword = params["description"].downcase
      item_results = Item.where("LOWER(description) like ?", "%#{keyword}%")
    elsif params["unit_price"] != nil
      keyword = params["unit_price"].to_f
      item_results = Item.where(:unit_price => keyword)
    elsif params["merchant_id"] != nil
      keyword = params["merchant_id"].to_i
      item_results = Item.where("merchant_id = #{keyword}")
    elsif params["created_at"] != nil
      keyword = params["created_at"].to_datetime
      item_results = Item.where(:created_at => keyword)
    elsif params["updated_at"] != nil
      keyword = params["updated_at"].to_datetime
      item_results = Item.where(:updated_at => keyword)
    end

    render json: ItemSerializer.new(item_results)
  end
end
