class Api::V1::RevenueController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.revenue_by_date(date_params))
  end

  private

  def date_params
    params.permit(:start, :end)
  end
end
