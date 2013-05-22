# == Schema Information
#
# Table name: shipping_methods
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShippingMethod < ActiveRecord::Base
  attr_accessible :name
  has_many :shipping_costs, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

   # State Machine
  state_machine :initial => :active do

    after_transition :on => :inactivate, :do => :inactivate_costs
    after_transition :on => :activate, :do => :activate_costs

    event :inactivate do
      transition :inactive => :inactive
      transition :active   => :inactive
    end

    event :activate do
      transition :inactive => :active
      transition :active   => :active
    end
  end

  def inactivate_costs
    self.shipping_costs.each { |cost| cost.inactivate! }
  end

  def activate_costs
    self.shipping_costs.each { |cost| cost.activate! }
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
