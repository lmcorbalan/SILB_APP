class Admin::UsersController < Admin::BaseController
  before_filter :himself,        only: :destroy
  helper_method :sort_column, :sort_direction

  def index
    @users = User.search_admins( { search: params[:search] } )
      .order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.toggle!(:admin)
      @user.activate!
      flash[:success] = t('user_successfully_created')
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      sign_in @user if current_user?(@user)
      flash[:success] = t('user_successfully_updated')
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('user_successfully_removed')
    redirect_to admin_users_path
  end

  private

    def himself
      redirect_to(admin_users_path) if current_user?(User.find(params[:id]))
    end

    def sort_column
        User.column_names.include?(params[:sort].to_s) ? params[:sort] : "id"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end
end

