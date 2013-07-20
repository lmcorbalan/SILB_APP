class OrdersController < ApplicationController
  before_filter :customer
  before_filter :shopping_cart,   only: [:show]

  def index
    @orders = @current_user.orders
  end

  def show
  end

end
