class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :admin_user
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_url, :alert => exception.message
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end

end