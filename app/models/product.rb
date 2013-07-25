# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  code                 :string(255)
#  name                 :string(255)
#  description          :text
#  category_id          :integer
#  brand_id             :integer
#  price_cents          :integer
#  current_stock        :integer
#  minimum_stock        :integer
#  highlight_stock_from :integer
#  state                :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Product < ActiveRecord::Base
  attr_accessible :code,
    :name, :description, :category_id, :brand_id, :current_stock,
    :highlight_stock_from, :minimum_stock, :price_cents, :price

  belongs_to :brand
  belongs_to :category

  has_many :pictures, :as => :imageable

  before_save {
    name.downcase!
    code.downcase!
  }

  validates :code, :name, :description,
            :category_id, :brand_id, :current_stock,
            :minimum_stock, :highlight_stock_from,
    :presence => true

  validates :code, :name,
    length: { maximum: 50 },
    uniqueness: { case_sensitive: false }

  validates :current_stock, :highlight_stock_from, :minimum_stock,
    :numericality => {
      :only_integer => true,
      :greater_than_or_equal_to => 0
    }

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

  def name
    read_attribute(:name).try(:titleize)
  end

  def in_stock?
    current_stock > 0
  end

  def remove_stock(quantity)
    self.current_stock = self.current_stock - quantity
    save!
  end

  def self.search(search, order)
    string_or_where = []
    string_where    = []
    bind            = {}

    if search

      string_or_where << 'code LIKE :code' if search[:code].present?
      bind[:code] = "%#{search[:code]}%"

      string_or_where << 'name LIKE :name' if search[:name].present?
      bind[:name] = "%#{search[:name]}%"

      string_where << 'brand_id = :brand_id' if search[:brand_id].present?
      bind[:brand_id] = search[:brand_id]

      if search[:category_id].present?
        category = Category.find(search[:category_id])
        if category.has_children?
          string_where << 'category_id IN (:categories_ids)'
          bind[:categories_ids] = category.subtree_ids
        else
          string_where << 'category_id = :category_id'
          bind[:category_id] = category.id
        end

      end
    end

    order_by = 'code ASC'
    joins_on = ''

    if order && ( order[:col] == 'brand_id' )
      order_by = "brands.name" + " " + order[:dir]
      joins_on = :brand
    elsif order && ( order[:col] == 'category_id' )
      order_by = "categories.name" + " " + order[:dir]
      joins_on = :category
    end

    str_w = ""
    str_w = string_or_where.join(" OR ") if !string_or_where.blank?
    str_w = !str_w.blank? && !string_where.blank? ? [str_w, string_where].join(" AND ") :
      str_w.blank? ? string_where : str_w

    where( str_w, bind ).joins( joins_on ).order( order_by )

  end

  def self.catalog_search(search)
    string_or_where = []
    string_where = ""
    bind         = {}

    if search

      string_or_where << 'code LIKE :code' if search[:code].present?
      bind[:code] = "%#{search[:code]}%"

      string_or_where << 'name LIKE :name' if search[:name].present?
      bind[:name] = "%#{search[:name]}%"

      if search[:category_id].present?
        category = Category.find(search[:category_id])
        if category.has_children?
          string_where = 'category_id IN (:categories_ids)'
          bind[:categories_ids] = category.subtree_ids
        else
          string_where = 'category_id = :category_id'
          bind[:category_id] = category.id
        end

      end
    end

    order_by = 'name ASC'

    str_w = ""
    str_w = string_or_where.join(" OR ") if !string_or_where.blank?
    str_w = !str_w.blank? && !string_where.blank? ? [str_w, string_where].join(" AND ") :
      str_w.blank? ? string_where : str_w

    str_w = !str_w.blank? ? ["(#{str_w})", "state = 'active'"].join(" AND ") : "state = 'active'"

    where( str_w, bind ).order( order_by )

  end

end
