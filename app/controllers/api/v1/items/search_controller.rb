class Api::V1::Items::SearchController < ApplicationController
  def index
    keyword = params[:keyword].downcase

    item_results = Item.where("LOWER(name) like ?", "%#{keyword}%")
    render json: ItemSerializer.new(item_results)
  end
end
