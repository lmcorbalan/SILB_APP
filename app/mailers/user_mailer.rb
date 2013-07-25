class UserMailer < ActionMailer::Base
  default from: "noreplay@silb.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => "#{user.name} <#{user.email}>", :subject => t('password_reset')
  end

  def user_activation(user)
    @user = user
    mail :to => "#{user.name} <#{user.email}>", :subject => t('welcome_silb')
  end

  def order_purchased(user, order)
    @user  = user
    @order = order

    mail :to => "#{user.name} <#{user.email}>", :subject => t( 'user_mailer.order_purchased.subject', id: @order.id )
  end

  def admin_order_purchased(user, order)
    @user  = user
    @order = order

    mail :to => "#{user.name} <#{user.email}>", :subject => t( 'user_mailer.admin_order_purchased.subject', id: @order.id )
  end

  def admin_order_purchased_error(user, order)
    @user  = user
    @order = order

    mail :to => "#{user.name} <#{user.email}>", :subject => t( 'user_mailer.admin_order_purchased_error.subject', id: @order.id )
  end
end
