class  Api::V1::Merchants::SearchController < ApplicationController
  def index
    keyword = params[:keyword].downcase

    merchant_results = Merchant.where("LOWER(name) like ?", "%#{keyword}%")
    render json: MerchantSerializer.new(merchant_results)
  end
end
