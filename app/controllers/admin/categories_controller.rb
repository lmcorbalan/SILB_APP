class Admin::CategoriesController < Admin::BaseController

  def index
  end

  def new
    @category   = Category.new
    @categories = Category.arrange_as_array({:order => 'name'}, @category.possible_parents)
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      params[:activate] ? @category.activate! : @category.inactivate!
      flash[:success] = t('category_successfully_created')
      redirect_to admin_categories_path
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
    @categories = Category.arrange_as_array({:order => 'name'}, @category.possible_parents)
  end

  def update
    @category = Categoryfind(params[:category])
    if @category.update_attributes( params[:category] )
      params[:activate] ? @category.activate! : @category.inactivate!
      flash[:success] = t('category_successfully_updated')
      redirect_to admin_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = t('category_successfully_removed')
    redirect_to admin_categories_path
  end

  private

    def sort_column
        %w(id name parent_name).include?(params[:sort].to_s) ? params[:sort] : "id"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end

end
