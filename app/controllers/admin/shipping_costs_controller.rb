class Admin::ShippingCostsController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @section = get_shipping_method.name + '::' + t('shipping_costs')
    @shipping_costs = search_shipping_cost
    @regions = get_regions_to_json
  end

  def new
    @shipping_cost = get_shipping_method.shipping_costs.build
    @regions = get_regions_to_json
  end

  def create
    @shipping_cost = get_shipping_method.shipping_costs.build(params[:shipping_cost])

    @shipping_cost.city = City.find(params[:city][:id])

    if @shipping_cost.save
      params[:activate] ? @shipping_cost.activate! : @shipping_cost.inactivate!
      flash[:success] = t('shipping_cost_successfully_created')
      redirect_to admin_shipping_costs_path(shipping_method_id: params[:shipping_method_id])
    else
      @regions = get_regions_to_json
      render 'new'
    end
  end

  def edit
    @shipping_cost = ShippingCost.find(params[:id])

    @regions = get_regions_to_json
    @selected_city = @shipping_cost.city.to_json(
      :only => [ :id ],
      :include => {
          :region => {
              :only => [ :id ]
          }
      }
    )
  end

  def update
    @shipping_cost = ShippingCost.find(params[:id])

    @shipping_cost.city = City.find(params[:city][:id])

    if @shipping_cost.update_attributes( params[:shipping_cost] )
      params[:activate] ? @shipping_cost.activate! : @shipping_cost.inactivate!
      flash[:success] = t('city_successfully_updated')
      redirect_to admin_shipping_costs_path(shipping_method_id: params[:shipping_method_id])
    else
      @regions = get_regions_to_json
      @selected_city = @shipping_cost.city.to_json(
        :only => [ :id ],
        :include => {
            :region => {
                :only => [ :id ]
            }
        }
      )
      render 'edit'
    end
  end

  private

    def search_shipping_cost
      ShippingCost.search( search_params, {col: sort_column, dir: sort_direction} )
        .paginate(per_page: 10, page: params[:page])
      # if sort_column == 'city'
      #   ShippingCost.search( search_params, {col: sort_column, dir: sort_direction} ).joins(:city => [:region]).order("regions.name, cities.name" + " " + sort_direction )
      #     .paginate(per_page: 10, page: params[:page])
      # else
      #   ShippingCost.search( search_params )
      #     .order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
      # end
    end

    def get_shipping_costs
      get_shipping_method.shipping_costs
    end

    def get_shipping_method
      ShippingMethod.find(params[:shipping_method_id])
    end

    def get_regions_to_json
      Region.all.to_json(
        :only => [ :id, :name ],
        :include => {
            :cities => {
                :only => [ :id, :name ]
            }
        }
      )
    end

    def search_params
      binds = {}
      binds[:shipping_method_id] = params[:shipping_method_id]
      binds[:city_id] = ''

      city = params[:city] ? params[:city][:id] : ''
      region = params[:region] ? params[:region][:id] : ''

      if !city.blank?
        binds[:city_id] = city
      elsif !region.blank?
        binds[:city_id] = Region.find(region).cities
      end

      return binds
    end

    def sort_column
      %w(id price_cents city).include?(params[:sort].to_s) ? params[:sort] : "id"
    end

    def sort_direction
      %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end
end
