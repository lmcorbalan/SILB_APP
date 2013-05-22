class Admin::ShippingMethodsController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @shipping_methods = ShippingMethod.search(params[:search]).order(sort_column + " " + sort_direction)
        .paginate(per_page: 10, page: params[:page])
  end

  def new
    @shipping_method = ShippingMethod.new
  end

  def create
    @shipping_method = ShippingMethod.create(params[:shipping_method])
    if @shipping_method.save
      params[:activate] ? @shipping_method.activate! : @shipping_method.inactivate!
      flash[:success] = t('shipping_method_successfully_created')
      redirect_to admin_shipping_methods_path
    else
      render 'new'
    end
  end

  def edit
    @shipping_method = ShippingMethod.find(params[:id])
  end

  def update
    @shipping_method = ShippingMethod.find(params[:id])
    if @shipping_method.update_attributes(params[:shipping_method])
      params[:activate] ? @shipping_method.activate! : @shipping_method.inactivate!
      flash[:success] = t('shipping_method_successfully_updated')
      redirect_to admin_shipping_methods_path
    else
      render 'edit'
    end
  end

  private

    def sort_column
        ShippingMethod.column_names.include?(params[:sort].to_s) ? params[:sort] : "id"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end

end
