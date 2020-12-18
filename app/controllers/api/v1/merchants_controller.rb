class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def create
    render json: MerchantSerializer.new(Merchant.create(merchant_params))
  end

  def update
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  def destroy
    MerchantSerializer.new(Merchant.delete(params[:id]))
  end

  def most_revenue
    render json: MerchantSerializer.new(MerchantFacade.merchants_with_most_revenue(params[:quantity]))
  end

  def most_items_sold
    # render json: MerchantSerializer.new(Merchant.most_items_sold(params[:quantity]))
    render json: MerchantSerializer.new(MerchantFacade.merchants_with_most_items_sold(params[:quantity]))
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
