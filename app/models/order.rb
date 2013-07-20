# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  state        :string(255)
#  purchased_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Order < ActiveRecord::Base
  has_many :line_items
  belongs_to :user
  has_one :shipping_address
  has_one :shipping_cost, through: :shipping_address
  has_one :payment, :class_name => "OrderPayment"

  # State Machine
  state_machine :initial => :checkout_pending do

    after_transition :checkout_pending => :successful_purchase do |order|
      order.update_attribute(:purchased_at, Time.now)

      UserMailer.order_purchased(order.user, order).deliver

      User.search_admins(nil).each do |admin|
        UserMailer.admin_order_purchased(admin, order).deliver if admin.is?('orders_admin')
      end

      order.items.each do |item|
        item.sold
      end

    end

    after_transition :checkout_pending => :unsuccessful_purchase do |order|
      User.search_admins(nil).each do |admin|
        UserMailer.admin_order_purchased_error(admin, order).deliver if admin.is?('orders_admin')
      end
    end

    event :successfully_purchased do
      transition :checkout_pending => :successful_purchase
    end

    event :unsuccessfully_purchased do
      transition :checkout_pending => :unsuccessful_purchase
    end

    event :next_state do
      transition :successful_purchase  => :dispatched
      transition :dispatched           => :committed
      transition :committed            => :committed
    end

  end

  def purchased?
    successful_purchase? || dispatched? || committed?
  end

  def items
    line_items.joins(:product).where( products:{ state: 'active' } ).readonly(false)
  end

  def sub_total
    s_total = Money.new(0)
    items.each do |item|
      s_total += item.amount
    end
    return s_total
  end

  def total
    return sub_total + shipping_cost.price if shipping_cost
  end

  def contain?(product)
    line_items.where( product_id: product.id ).any?
  end

  def detail_for_paypal
    detail = []

    items.each do |item|
      #  get the amount of the line to update it, if there are no more stock
      if item.quantity > 0
        amount = item.usd_amount
        product = item.product
        detail << { :name => product.name, :description => product.description,
                    :amount => amount.cents, :quantity => item.quantity }
      end
    end

    if detail.any?
      detail << { :name => I18n.t("shipping_cost"), :description => shipping_cost.description,
                  :amount => shipping_cost.usd_amount.cents, :quantity => '1' }
    end

    return detail
  end

end
