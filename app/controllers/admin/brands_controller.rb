class Admin::BrandsController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @brands = Brand.search(params[:search]).order(sort_column + " " + sort_direction)
        .paginate(per_page: 10, page: params[:page])
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.create(params[:brand])
    if @brand.save
      params[:activate] ? @brand.activate! : @brand.inactivate!
      flash[:success] = t('brand_successfully_created')
      redirect_to admin_brands_path
    else
      render 'new'
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      params[:activate] ? @brand.activate! : @brand.inactivate!
      flash[:success] = t('brand_successfully_updated')
      redirect_to admin_brands_path
    else
      render 'edit'
    end
  end

  private

    def sort_column
        Brand.column_names.include?(params[:sort].to_s) ? params[:sort] : "id"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end
end
