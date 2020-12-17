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

  def revenue
    render json: RevenueSerializer.new(RevenueFacade.merchant_total_revenue(params[:id]))
  end

  def most_revenue

  end

  private

  def merchant_params
    params.permit(:name)
  end
end
