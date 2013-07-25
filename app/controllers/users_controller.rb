class UsersController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]

  before_filter :is_signed,      only: [:new, :create]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_activation_token
      flash[:success] = t('user_created_successfully_message')
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = t('profile_updated_successfully_message')
      sign_in @user
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def himself
      redirect_to(root_path) if current_user?(User.find(params[:id]))
    end

    def is_signed
      redirect_to(root_path) unless !signed_in?
    end
end
