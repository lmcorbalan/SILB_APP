class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :unit_price_cents
      t.integer :quantity

      t.timestamps
    end
  end
end
