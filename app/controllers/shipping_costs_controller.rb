class ShippingCostsController < ApplicationController

  def index
    @shipping_costs = ShippingCost.where(city_id: params[:id], state: 'active').all
    @shipping_costs_js = @shipping_costs.collect { |sc| sc.to_js }.to_json

    respond_to do |format|
      format.js
    end
  end

end
