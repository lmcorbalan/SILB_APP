# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Country < ActiveRecord::Base
  attr_accessible :name
  has_many :regions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

  # State Machine
  state_machine :initial => :active do

    after_transition :on => :inactivate, :do => :inactivate_regions
    after_transition :on => :activate, :do => :activate_regions

    event :inactivate do
      transition :inactive => :inactive
      transition :active   => :inactive
    end

    event :activate do
      transition :inactive => :active
      transition :active   => :active
    end
  end

  def inactivate_regions
    self.regions.each { |region| region.inactivate! }
  end

  def activate_regions
    self.regions.each { |region| region.activate! }
  end
end
