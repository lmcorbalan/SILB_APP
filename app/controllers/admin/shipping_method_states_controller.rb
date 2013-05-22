class Admin::ShippingMethodStatesController < Admin::BaseController

  def update
    @shipping_method = ShippingMethod.find(params[:id])

    if params[:state]
      if @shipping_method.activate!
        @message = { type: 'success', content: t('shipping_method_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    else
      if @shipping_method.inactivate!
        @message = { type: 'success', content: t('shipping_method_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_shipping_methods_path }
      format.js
    end
  end
end
