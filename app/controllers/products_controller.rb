class ProductsController < ApplicationController

  def index
    @products = Product.catalog_search(search_params).paginate(per_page: 21, page: params[:page])
  end

  def show
    @product = Product.find(params[:id])
  end

  private
    def search_params
      binds = {}
      binds[:code]        = params[:search] if defined? params[:search] && !params[:search].blank?
      binds[:name]        = params[:search] if defined? params[:search] && !params[:search].blank?
      binds[:category_id] = params[:category] if defined? params[:category] && !params[:category].blank?

      return binds
    end
end
