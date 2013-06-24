# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  ancestry   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string(255)
#

class Category < ActiveRecord::Base
  attr_accessible :parent_id, :name

  has_ancestry :orphan_strategy => :adopt

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

  def self.arrange_as_array(options={}, hash=nil)
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.nil?
    end
    arr
  end

  def name_for_selects
    "#{'-' * depth} #{name}"
  end

  def possible_parents
    parents = Category.arrange_as_array(:order => 'name')
    return new_record? ? parents : parents - subtree
  end

end
