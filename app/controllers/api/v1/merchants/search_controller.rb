class  Api::V1::Merchants::SearchController < ApplicationController
  def index
    if params["name"] != nil
      keyword = params["name"].downcase
      merchant_results = Merchant.where("LOWER(name) LIKE ?", "%#{keyword}%")
    elsif params["created_at"] != nil
      keyword = params["created_at"].to_datetime
      merchant_results = Merchant.where(:created_at => keyword)
    elsif params["updated_at"] != nil
      keyword = params["updated_at"].to_datetime
      merchant_results = Merchant.where(:created_at => keyword)
    end
    render json: MerchantSerializer.new(merchant_results)
  end

  def show
    keyword = params[:keyword].downcase

    merchant_result = Merchant.where("LOWER(name) LIKE ?", "%#{keyword}%").limit(1)
    render json: MerchantSerializer.new(merchant_result)
  end
end
