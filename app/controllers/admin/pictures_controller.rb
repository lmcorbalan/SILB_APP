class Admin::PicturesController < Admin::BaseController
  before_filter :load_imageable, :only => [:index, :create]

  def index
    @pictures = @imageable.pictures
    # @pictures = Picture.where(imageable_id: params[:imageable_id], imageable_type: params[:imageable_type])
    render :json => @pictures.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    @picture = @imageable.pictures.build(params[:picture])
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

  private
    def load_imageable
      klass = [Product, Brand].detect { |c| params["#{c.name.underscore}_id"] }
      @imageable = klass.find(params["#{klass.name.underscore}_id"])
    end

end
