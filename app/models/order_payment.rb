# == Schema Information
#
# Table name: order_payments
#
#  id               :integer          not null, primary key
#  order_id         :integer
#  ip_address       :string(255)
#  first_name       :string(255)
#  last_name        :string(255)
#  express_token    :string(255)
#  express_payer_id :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class OrderPayment < ActiveRecord::Base
  belongs_to :order
  has_many :transactions, :class_name => "PaymentTransaction"

  attr_accessible :express_token

  def purchase
    response = process_purchase
    transactions.create!(:action => "purchase", :amount => usd_amount.cents, :response => response)
    response.success?
  end

  def usd_amount
    order.total.exchange_to("USD")
  end

  def express_token=(token)
    self[:express_token] = token
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
    end
  end

  include Rails.application.routes.url_helpers
  def options_for_paypal
    # paypal do not accept shippings from USA to Argentina
    # :shipping_address  => order.shipping_address.detail_for_paypal,
    # :address_override  => true,
    {
      :no_shipping => true,
      :email       => order.user.email,
      :items       => order.detail_for_paypal
    }
  end

  private
    def process_purchase
      if !express_token.blank?
        EXPRESS_GATEWAY.purchase(usd_amount.cents, express_purchase_options)
      end
    end

    def express_purchase_options
      purchase_options = options_for_paypal

      purchase_options[:id]       = ip_address
      purchase_options[:token]    = express_token
      purchase_options[:payer_id] = express_payer_id

      return purchase_options
    end

end
