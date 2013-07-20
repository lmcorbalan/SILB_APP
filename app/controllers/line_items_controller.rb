class LineItemsController < ApplicationController
  before_filter :customer
  before_filter :shopping_cart

  def create
    quantity = params[:quantity] || 1
    product = Product.find(params[:id])

    if !@shopping_cart.contain?(product)
      line = LineItem.new(order: @shopping_cart, product: product, quantity: quantity)
      if line.save
        flash[:success] = t('product_successfully_added')
        redirect_to shopping_cart_path
      else
        flash[:error] = t('an_error_occurred_while_trying_to_add_the_product')
        render product_path(product)
      end
    else
      flash[:info] = t('product_alredy_in_cart')
      redirect_to shopping_cart_path
    end
  end

  def update
    @line_item = LineItem.find(params[:id])

    @line_item.update_attributes( params[:line_item] )

    respond_to do |format|
      format.html { redirect_to shopping_cart_path }
      format.js
    end
  end

  def destroy
    LineItem.find(params[:id]).destroy
    flash[:success] = t('product_successfully_removed')
    redirect_to shopping_cart_path
  end
end
