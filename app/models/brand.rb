# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Brand < ActiveRecord::Base
  attr_accessible :name

  has_many :products

  before_save { name.downcase! }

  validates :name,
    presence: true,
    length: { maximum: 50 },
    uniqueness: { case_sensitive: false }

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

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
