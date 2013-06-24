class Admin::BrandStatesController < Admin::BaseController

  def update
    @brand = Brand.find(params[:id])

    if params[:state]
      if @brand.activate!
        @message = { type: 'success', content: t('brand_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    else
      if @brand.inactivate!
        @message = { type: 'success', content: t('brand_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_brands_path }
      format.js
    end
  end
end
