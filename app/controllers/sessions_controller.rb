class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.active? && user.authenticate(params[:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user, permanent: params[:remember_me]
      redirect_back_or root_url
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = t('invalid_email_password_conbination')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end

