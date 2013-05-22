class ChangeShippingCostCost < ActiveRecord::Migration
  change_table :shipping_costs do |t|
      t.remove :cost
      t.integer :price_cents
  end
end
