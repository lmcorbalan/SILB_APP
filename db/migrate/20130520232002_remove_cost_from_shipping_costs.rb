class RemoveCostFromShippingCosts < ActiveRecord::Migration
  def up
    remove_column :shipping_costs, :cost
    remove_column :shipping_costs, :price_cent
  end

  def down
    add_column :shipping_costs, :cost, :float
    add_column :shipping_costs, :price_cent, :integer
  end
end
