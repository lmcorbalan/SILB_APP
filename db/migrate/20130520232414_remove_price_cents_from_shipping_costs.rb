class RemovePriceCentsFromShippingCosts < ActiveRecord::Migration
  def up
    remove_column :shipping_costs, :price_cents
  end

  def down
    add_column :shipping_costs, :price_cents, :integer
  end
end
