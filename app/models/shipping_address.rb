# == Schema Information
#
# Table name: shipping_addresses
#
#  id                  :integer          not null, primary key
#  order_id            :integer
#  reference_name      :string(255)
#  reference_last_name :string(255)
#  company_name        :string(255)
#  reference_phone     :string(255)
#  shipping_cost_id    :integer
#  zip_code            :string(255)
#  shipping_address_1  :string(255)
#  shipping_address_2  :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ShippingAddress < ActiveRecord::Base
  attr_accessible :company_name, :reference_last_name,
                  :reference_name, :reference_phone,
                  :shipping_address_1, :shipping_address_2,
                  :shipping_cost_id, :zip_code, :order_id

  belongs_to :order
  belongs_to :shipping_cost

  validates :reference_last_name, :reference_name, :reference_phone,
            :shipping_address_1, :zip_code, :shipping_cost_id,
    :presence => true

  def detail_for_paypal

    {
      :name      => "#{reference_last_name}, #{reference_name}",
      :company   => company_name,
      :address1  => shipping_address_1,
      :address2  => shipping_address_2,
      :city      => shipping_cost.city.name,
      :state     => shipping_cost.city.region.name,
      :country   => 'US',
      :zip       => zip_code,
      :phone     => reference_phone
    }
  end

end
