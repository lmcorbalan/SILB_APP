class ShippingAddressesController < ApplicationController
  before_filter :customer
  before_filter :shopping_cart

  def new
    @shipping_address = @shopping_cart.build_shipping_address
    @regions = get_regions_to_json
  end

  def create
    @shipping_address = @shopping_cart.build_shipping_address( params[:shipping_address] )
    if @shipping_address.save
      redirect_to express_path
    else
      render 'new'
    end
  end

  private
    def get_regions_to_json
      regions = {}
      ShippingCost.select("regions.id as ri, regions.name as rn, cities.id as ci, cities.name as cn")
        .joins(city: :region).where("shipping_costs.state = 'active' AND cities.state = 'active'").each  do |a|
          regions[a.ri] = {} if regions[a.ri].nil?
          regions[a.ri]['name'] = a.rn
          regions[a.ri]['cities'] = {} if regions[a.ri]['cities'].nil?
          regions[a.ri]['cities'][a.ci] = a.cn
      end
      return regions.to_json()
    end
end
