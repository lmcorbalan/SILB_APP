class RemoveRegionIdFromShippingCost < ActiveRecord::Migration
  def up
    remove_column :shipping_costs, :region_id
  end

  def down
    add_column :shipping_costs, :region_id, :string
  end
end
