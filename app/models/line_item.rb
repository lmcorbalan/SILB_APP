# == Schema Information
#
# Table name: line_items
#
#  id               :integer          not null, primary key
#  order_id         :integer
#  product_id       :integer
#  unit_price_cents :integer
#  quantity         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class LineItem < ActiveRecord::Base
  attr_accessible :product, :order, :quantity

  belongs_to :order
  belongs_to :product

  monetize :unit_price_cents, :allow_nil => true

  def amount
    # can't change the quantity if the order has already been purchased
    if  !order.purchased?
      if quantity > product.current_stock
        self.quantity = product.current_stock
        save!
      elsif quantity == 0 && product.current_stock >= 1
        self.quantity = 1
        save!
      end
    end

    !order.purchased? ? product.price * quantity : unit_price * quantity
  end

  def sold
    self.unit_price_cents = product.price_cents
    product.remove_stock(quantity)
    save!
  end

  def usd_amount
    am = product.price * quantity
    am.exchange_to("USD")
  end

end
