class AddPriceCentsToShippingCosts < ActiveRecord::Migration
  def change
    add_column :shipping_costs, :price_cents, :integer, :default => 0
  end
end
