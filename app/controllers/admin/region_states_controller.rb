class Admin::RegionStatesController < Admin::BaseController

  def update
    @region = Region.find(params[:id])

    if params[:state]
      if @region.activate!
        @message = { type: 'success', content: t('region_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    else
      if @region.inactivate!
        @message = { type: 'success', content: t('region_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_regions_path }
      format.js
    end
  end
end
