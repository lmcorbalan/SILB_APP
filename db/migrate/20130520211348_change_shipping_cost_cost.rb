class ChangeShippingCostCost < ActiveRecord::Migration
  change_table :shipping_costs do |t|
      t.remove :const
      t.integer :price_cents
  end
end
