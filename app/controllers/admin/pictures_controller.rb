class Admin::PicturesController < Admin::BaseController

  # def new
  #   @picture = Product.find(params[:imageable_id]).pictures.build
  # end

  # def create
  #   @picture = Product.find(params[:imageable_id]).pictures.build(params[:picture])
  #   if @picture.save
  #     flash[:notice] = t('picture_successfully_added')
  #     redirect_to edit_admin_product_path(@picture.imageable)
  #   else
  #     render :action => 'new'
  #   end
  # end

  # def destroy
  #   @picture = Picture.find(params[:id])
  #   @picture.destroy
  #   flash[:notice] = t('picture_successfully_removed')
  #   redirect_to edit_admin_product_path(@picture.imageable)
  # end
  def index
    @pictures = Picture.all
    render :json => @pictures.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    @picture = Product.find(params[:imageable_id]).pictures.build(params[:picture])
    if @picture.save
      respond_to do |format|
        format.html {
          render :json => [@picture.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => {:files => [@picture.to_jq_upload]}.to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    render :json => true
  end

end
