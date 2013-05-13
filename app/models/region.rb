# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  country_id :integer
#  state      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Region < ActiveRecord::Base
  attr_accessible :name
  belongs_to :country
  has_many :cities, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

  # State Machine
  state_machine :initial => :active do

    after_transition :on => :inactivate, :do => :inactivate_cities
    after_transition :on => :activate, :do => :activate_cities

    event :inactivate do
      transition :inactive => :inactive
      transition :active   => :inactive
    end

    event :activate do
      transition :inactive => :active
      transition :active   => :active
    end
  end

  def inactivate_cities
    self.cities.each { |city| city.inactivate! }
  end

  def activate_cities
    self.cities.each { |city| city.activate! }
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end
