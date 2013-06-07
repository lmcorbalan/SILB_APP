class Admin::RegionsController < Admin::BaseController

  helper_method :sort_column, :sort_direction

  before_filter :get_argentinian_regions, :only => :index
  before_filter :new_argentinian_region, :only => [:new, :create]

  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    if @region.save
      params[:activate] ? @region.activate! : @region.inactivate!
      flash[:success] = t('region_successfully_created')
      redirect_to admin_regions_path
    else
      render 'new'
    end
  end

  def edit
    @region = Region.find(params[:id])
  end

  def update
    @region = Region.find(params[:id])
    if @region.update_attributes(params[:region])
      params[:activate] ? @region.activate! : @region.inactivate!
      flash[:success] = t('region_successfully_updated')
      redirect_to admin_regions_path
    else
      render 'edit'
    end
  end

  private
    def new_argentinian_region
      @region = Country.find_by_name('Argentina').regions.build(params[:region])
    end

    def get_argentinian_regions
      @regions = Country.find_by_name('Argentina').regions.search(params[:search]).order(sort_column + " " + sort_direction)
        .paginate(per_page: 10, page: params[:page])
    end

    def sort_column
        Region.column_names.include?(params[:sort].to_s) ? params[:sort] : "id"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end
end
