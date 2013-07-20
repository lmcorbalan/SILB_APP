class OrderPaymentsController < ApplicationController
  before_filter :customer
  before_filter :shopping_cart
  before_filter :valid_shopping_cart?

  def express
    order_payment = @shopping_cart.build_payment
    amount        = order_payment.usd_amount.cents
    options       = order_payment.options_for_paypal
    options[:ip]  = request.remote_ip
    options[:return_url]        = new_order_payment_url
    options[:cancel_return_url] = paypal_cancel_url

    response = EXPRESS_GATEWAY.setup_purchase( amount, options )

    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    @order_payment = @shopping_cart.build_payment(:express_token => params[:token])
  end

  def create
    @order_payment = @shopping_cart.build_payment(params[:order_payment])
    @order_payment.ip_address = request.remote_ip

    if @order_payment.save
      if @order_payment.purchase
        @shopping_cart.successfully_purchased
        flash[:success] = t('order_successfully_purchased')
        redirect_to orders_path
      else
        @shopping_cart.unsuccessfully_purchased
        flash[:error] = t('order_unsuccessfully_purchased')
        redirect_to shopping_cart_path
      end
    else
      render :action => 'new'
    end
  end

  def paypal_cancel
    @shopping_cart.shipping_address.destroy
    flash[:error] = t('paypal_setup_cancel')
    redirect_to shopping_cart_path
  end

  private

    def valid_shopping_cart?
      redirect_to shopping_cart_path unless @shopping_cart.shipping_cost
    end

end
