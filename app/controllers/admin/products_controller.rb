class Admin::ProductsController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @products = Product.search(search_params, {col: sort_column, dir: sort_direction})
        .paginate(per_page: 10, page: params[:page])

    @categories = Category.arrange_as_array(:order => 'name')
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      params[:activate] ? @product.activate! : @product.inactivate!
      flash[:success] = t('product_successfully_created')
      redirect_to admin_products_path
    else
      render 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      params[:activate] ? @product.activate! : @product.inactivate!
      flash[:success] = t('product_successfully_updated')
      redirect_to admin_products_path
    else
      render 'edit'
    end
  end

  private
    def search_params
      binds = {}
      binds[:code]        = params[:code] if defined? params[:code] && !params[:code].blank?
      binds[:name]        = params[:name] if defined? params[:name] && !params[:name].blank?
      binds[:category_id] = params[:category_id] if defined? params[:category_id] && !params[:category_id].blank?
      binds[:brand_id]    = params[:brand_id] if defined? params[:brand_id] && !params[:brand_id].blank?

      return binds
    end

    def sort_column
        Product.column_names.include?(params[:sort].to_s) ? params[:sort] : "code"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end

end
