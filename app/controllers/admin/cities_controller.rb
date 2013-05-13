class Admin::CitiesController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @regions = get_argentinian_regions
    @cities = City.search( { name: params[:search], region_id: params[:region_id] } )
      .order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
  end

  def new
    @regions = get_argentinian_regions
    @city    = City.new
  end

  def create
    @city = Region.find(params[:region][:region_id]).cities.build(params[:city])
    if @city.save
      params[:activate] ? @city.activate! : @city.inactivate!
      flash[:success] = t('city_successfully_created')
      redirect_to admin_path
    else
      render 'new'
    end
  end

  def edit
    @regions = get_argentinian_regions
    @city = City.find(params[:id])
  end

  def update
    @city = City.find(params[:id])
    @city.region = Region.find(params[:region][:region_id])
    if @city.update_attributes( params[:city] )
      params[:activate] ? @city.activate! : @city.inactivate!
      flash[:success] = t('city_successfully_updated')
      redirect_to admin_path
    else
      render 'edit'
    end
  end

  private
    def get_argentinian_regions
      Country.find_by_name('Argentina').regions.all
    end

    def sort_column
        Region.column_names.include?(params[:sort].to_s) ? params[:sort] : "name"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end

end
