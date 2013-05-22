# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  region_id  :integer
#  state      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class City < ActiveRecord::Base
  attr_accessible :name
  belongs_to :region
  has_many :shipping_costs, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

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

  def self.search(params)

    if params
      string_where = []
      binds = {}

      string_where << 'name LIKE :name' if params[:name].present?
      binds[:name ] = "%#{params[:name]}%"

      string_where << 'region_id = :region_id' if params[:region_id].present?
      binds[:region_id] = params[:region_id]

      where(string_where.join(" AND "), binds)
    else
      scoped
    end
  end
end
