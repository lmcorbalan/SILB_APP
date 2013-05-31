# == Schema Information
#
# Table name: shipping_costs
#
#  id                 :integer          not null, primary key
#  description        :text
#  state              :string(255)
#  shipping_method_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  city_id            :integer
#  price_cents        :integer          default(0)
#

class ShippingCost < ActiveRecord::Base
  attr_accessible :price_cents, :price, :description
  belongs_to :shipping_method
  belongs_to :city

  validates :description, presence: true

  monetize :price_cents,
           :numericality => { :message => {
             :invalid_currency => I18n.t("errors.messages.invalid_currency",
                thousands: I18n.t("number.format.delimiter"), decimal: I18n.t("number.format.separator")
              ),
             :not_a_number => I18n.t("errors.messages.not_a_number")
           } },
           :allow_nil => false

  # State Machine
  state_machine :initial => :active do

    event :inactivate do
      transition :inactive => :inactive
      transition :active   => :inactive
    end

    event :activate do
      transition :inactive => :active
      transition :active   => :active
    end
  end

  def self.search( search, order )

    if search
      string_where = []

      if search [:city_id].present?
        if search [:city_id].class == Array
          cities = []

          search  [:city_id].each { |city|
            cities << city.id
          }

          string_where << 'city_id IN (:city_id)'
          search  [:city_id] = cities
        else
          string_where << 'city_id = :city_id'
        end
      end

      string_where << 'shipping_method_id = :shipping_method_id' if search  [:shipping_method_id].present?

      order_by = 'id ASC'
      joins_on = {}
      if order && ( order[:col] == 'city' )
        order_by = "regions.name, cities.name" + " " + order[:dir]
        joins_on[:city] = [:region]
      elsif order
        order_by = order[:col] + " " + order[:dir]
      end

      where( string_where.join(" AND "), search ).joins( joins_on ).order( order_by )
    else
      scoped
    end
  end
end
