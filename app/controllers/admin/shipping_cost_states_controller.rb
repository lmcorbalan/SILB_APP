class Admin::ShippingCostStatesController < Admin::BaseController

  def update
    @shipping_cost = ShippingCost.find(params[:id])

    if params[:state]
      if @shipping_cost.activate!
        @message = { type: 'success', content: t('shipping_cost_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    else
      if @shipping_cost.inactivate!
        @message = { type: 'success', content: t('shipping_cost_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    end

    respond_to do |format|
      format.html {
        redirect_to admin_shipping_costs_path( shipping_method: @shipping_cost.shipping_method.id)
      }
      format.js
    end
  end
end
