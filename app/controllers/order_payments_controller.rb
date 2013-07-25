class OrderPaymentsController < ApplicationController
  before_filter :customer
  before_filter :shopping_cart
  before_filter :valid_shopping_cart?

  def express
    order_payment                       = @shopping_cart.build_payment
    setup                               = order_payment.setup_for_paypal
    setup[:options][:ip]                = request.remote_ip
    setup[:options][:return_url]        = new_order_payment_url
    setup[:options][:cancel_return_url] = paypal_cancel_url

    logger.debug { "ammount => #{setup[:amount]}" }
    logger.debug { "options => #{setup[:options]}" }

    response = EXPRESS_GATEWAY.setup_purchase( setup[:amount], setup[:options] )

    logger.debug { "RESPONSE => #{response.token}" }
    logger.debug { "RESPONSE => #{response.message}" }
    logger.debug { "RESPONSE => #{response.params}" }

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
