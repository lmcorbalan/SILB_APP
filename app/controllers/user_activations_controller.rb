class UserActivationsController < ApplicationController
  def edit
    @user = User.find_by_activation_token!(params[:id])
    if @user && @user.inactive?
      @user.set_customer_role
      @user.activate!
      sign_in @user
      flash[:success] = t('welcome_silb')
      redirect_to root_path
    else
      flash[:success] = t('please_sign_in')
      redirect_to signin_url
    end
  end
end
