class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
