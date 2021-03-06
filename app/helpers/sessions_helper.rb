module SessionsHelper

  def sign_in(user, options = {})
    if  options[:permanent]
      cookies.permanent[:remember_token] = user.remember_token
    else
      cookies[:remember_token] = user.remember_token
    end
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: t('please_sign_in')
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def admin_user
    redirect_to(root_path) unless current_user && current_user.admin?
  end

  def admin_user?
    current_user && current_user.admin?
  end

  def customer
    if !signed_in?
      redirect_to signin_url, notice: t('please_sign_in')
    elsif admin_user?
      redirect_to root_path, notice: t('not_allowed_action')
    end
  end

  def customer?
    current_user && !current_user.admin?
  end

  def shopping_cart
    @shopping_cart ||= current_user.get_shopping_cart
  end
end
