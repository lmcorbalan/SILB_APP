class UsersController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  # before_filter :admin_user,     only: :destroy

  #mios
  # before_filter :himself,        only: :destroy
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
    # @user = User.find(params[:id]) --> se comenta porque @user pasa a ser creado en correct_user, llamado en el before_filtes
  end

  def update
    # @user = User.find(params[:id]) --> se comenta porque @user pasa a ser creado en correct_user, llamado en el before_filtes
    if @user.update_attributes(params[:user])
      flash[:success] = t('profile_updated_successfully_message')
      sign_in @user
      redirect_to root_path
    else
      render 'edit'
    end
  end

  # def destroy
  #   User.find(params[:id]).destroy
  #   flash[:success] = "User destroyed."
  #   redirect_to users_url
  # end

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
