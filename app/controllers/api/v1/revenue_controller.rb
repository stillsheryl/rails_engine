class Api::V1::RevenueController < ApplicationController
  def show
    render json: RevenueSerializer.new(RevenueFacade.total_revenue_by_date(date_params))
  end

  def revenue_for_merchant
    render json: RevenueSerializer.new(RevenueFacade.merchant_total_revenue(params[:id]))
  end

  private

  def date_params
    params.permit(:start, :end)
  end
end
