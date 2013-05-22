class AddCityIdFromShippingCost < ActiveRecord::Migration
  def change
    add_column :shipping_costs, :city_id, :integer
  end
end
