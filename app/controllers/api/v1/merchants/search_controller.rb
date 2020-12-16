class  Api::V1::Merchants::SearchController < ApplicationController
  def index
    keyword = params[:keyword].downcase

    if keyword.is_a?(Date)
      merchant_results = (Merchant.where("DATE(created_at) LIKE ?", "%#{keyword}%"))
      .or(Merchant.where("DATE(updated_at) LIKE ?", "%#{keyword}%"))
    else
      merchant_results = Merchant.where("LOWER(name) LIKE ?", "%#{keyword}%")
    end
    render json: MerchantSerializer.new(merchant_results)
  end

  def show
    keyword = params[:keyword].downcase

    merchant_result = Merchant.where("LOWER(name) LIKE ?", "%#{keyword}%").limit(1)
    render json: MerchantSerializer.new(merchant_result)
  end
end
