class CreateShippingCosts < ActiveRecord::Migration
  def change
    create_table :shipping_costs do |t|
      t.text :description
      t.float :cost
      t.string :state
      t.integer :shipping_method_id
      t.integer :region_id

      t.timestamps
    end
  end
end
