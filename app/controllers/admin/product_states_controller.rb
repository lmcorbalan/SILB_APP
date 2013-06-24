class Admin::ProductStatesController < Admin::BaseController

  def update
    @product = Product.find(params[:id])

    if params[:state]
      if @product.activate!
        @message = { type: 'success', content: t('product_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    else
      if @product.inactivate!
        @message = { type: 'success', content: t('product_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_products_path }
      format.js
    end
  end
end
