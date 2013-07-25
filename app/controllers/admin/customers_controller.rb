class Admin::CustomersController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @customers = User.search_customers( { search: params[:search] } )
      .order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
  end

  private

    def sort_column
        %w(id email name).include?(params[:sort].to_s) ? params[:sort] : "id"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end
end
