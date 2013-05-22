class Admin::CityStatesController < Admin::BaseController

  def update
    @city = City.find(params[:id])

    if params[:state]
      if @city.activate!
        @message = { type: 'success', content: t('city_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    else
      if @city.inactivate!
        @message = { type: 'success', content: t('city_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_cities_path }
      format.js
    end
  end
end