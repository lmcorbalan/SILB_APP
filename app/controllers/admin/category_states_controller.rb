class Admin::CategoryStatesController < Admin::BaseController

  def update
    @category = Category.find(params[:id])

    if params[:state]
      if @category.activate!
        @message = { type: 'success', content: t('category_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    else
      if @category.inactivate!
        @message = { type: 'success', content: t('category_successfully_updated') }
      else
        @message = { type: 'error',   content: t('an_error_occurred_the_action_could_not_be_completed') }
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_categories_path }
      format.js
    end
  end

end
