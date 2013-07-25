# == Schema Information
#
# Table name: orders
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  state             :string(255)
#  purchased_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  total_price_cents :integer
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
      order.items.each do |item|
        item.sold
      end

      UserMailer.order_purchased(order.user, order).deliver

      User.search_admins().each do |admin|
        UserMailer.admin_order_purchased(admin, order).deliver if admin.is?('orders_admin')
      end

      order.set_total_price

    end

    after_transition :checkout_pending => :unsuccessful_purchase do |order|
      User.search_admins().each do |admin|
        UserMailer.admin_order_purchased_error(admin, order).deliver if admin.is?('orders_admin')
      end
      order.set_total_price
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
    return self.shipping_cost ? sub_total + self.shipping_cost.price : sub_total
  end

  def contain?(product)
    line_items.where( product_id: product.id ).any?
  end

  def detail_for_paypal
    detail = []
    total_amount = 0

    items.each do |item|
      if item.quantity > 0
        amount  = item.product.price.exchange_to("USD")
        product = item.product
        detail << { :name   => product.name, :description => product.description,
                    :amount => amount.cents, :quantity    => item.quantity }
        total_amount += ( amount.cents * item.quantity )
      end
    end

    if detail.any?
      ship_amount = shipping_cost.usd_amount.cents
      detail << { :name   => I18n.t("shipping_cost"), :description => shipping_cost.description,
                  :amount => ship_amount,             :quantity    => '1' }
      total_amount += ship_amount
    end

    {
      amount: total_amount,
      items:  detail
    }

  end

  def self.search(search, order)
    string_or_where = []
    string_where    = []
    bind            = {}

    if search
      string_where << 'id = :id' if search[:id].present?
      bind[:id]        = search[:id]

      string_where << 'state = :state' if search[:state].present?
      bind[:state]     = search[:state]

      string_where << 'purchased_at >= :date_from' if search[:date_from].present?
      bind[:date_from] = search[:date_from]

      string_where << 'purchased_at <= :date_to' if search[:date_to].present?
      bind[:date_to]   = search[:date_to]

      if search[:email].present?
        users_ids = User.where('email LIKE :email', email: "%#{search[:email]}%").pluck(:id)
        string_where << 'user_id IN (:users_ids)'
        bind[:users_ids] = users_ids
      end

      string_where << 'user_id = :customer_id' if search[:customer_id].present?
      bind[:customer_id] = search[:customer_id]

    end

    order_by = 'id DESC'
    joins_on = ''

    if order && ( order[:id] == 'id' )
        order_by = "id" + " " + order[:dir]
    end

    if order && ( order[:col] == 'email' )
      order_by = "users.email" + " " + order[:dir]
      joins_on = :user
    elsif order
      order_by = order[:col] + " " + order[:dir]
    end

    where( string_where.join(" AND "), bind ).joins( joins_on ).order( order_by )

  end

  def set_total_price
    if purchased?
      tot_price = 0
      line_items.each do |item|
        # destroy line_items not purchased
        if item.quantity == 0 || item.product.inactive?
          item.destroy
        else
          tot_price += (item.unit_price_cents * item.quantity)
        end
      end
      self.total_price_cents = tot_price
      save!
    end
  end

  def self.sales_report_data(date_from = 3.weeks.ago, date_to = Date.today )
    report_data = {}

    totals = totals_by_day(date_from, date_to)
    report_data[:total_by_day] = (date_from.to_date..date_to.to_date).map do |date|
      {
        purchased_at: date,
        price:    totals[date] ? totals[date][:total_price] || 0 : 0,
        quantity: totals[date] ? totals[date][:quantity]    || 0 : 0
      }
    end
    report_data[:period_overview] = period_overview(date_from, date_to)
    report_data[:top_selling_products] = top_selling_products(date_from, date_to)

    return report_data
  end

  def self.totals_by_day(date_from, date_to)
    orders = where(purchased_at: date_from.beginning_of_day..date_to.end_of_day)
    orders = orders.group("date(purchased_at)").having("state NOT IN ('checkout_pending', 'unsuccessful_purchase')")
    orders = orders.select("purchased_at, sum(total_price_cents) as total_price, count(*) as quantity")
    orders.each_with_object({}) do |order, totals|
      totals[order.purchased_at.to_date] = {}
      totals[order.purchased_at.to_date][:total_price] = order.total_price
      totals[order.purchased_at.to_date][:quantity] = order.quantity
    end
  end

  def self.period_overview(date_from, date_to)
    orders = where(purchased_at: date_from.beginning_of_day..date_to.end_of_day)
    orders = orders.where("state NOT IN ('checkout_pending', 'unsuccessful_purchase')")
    orders = orders.select("sum(total_price_cents) as total_sales, count(*) as quantity")
    result = orders.first
    {
      total_sales: Money.new(result[:total_sales]),
      average_selling: Money.new(result[:total_sales]) / result[:quantity].to_i,
      quantity: result[:quantity]
    }
  end

  def self.top_selling_products(date_from, date_to)
    orders = joins(line_items: :product).where(purchased_at: date_from.beginning_of_day..date_to.end_of_day)
    orders = orders.group("products.id").select("products.name as name, products.code as code, sum(line_items.quantity) as quantity")

    orders.map do |order|
      {
        label: order.code,
        value: order.quantity
      }
    end
  end

end
