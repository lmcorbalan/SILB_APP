class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.text :description
      t.integer :category_id
      t.integer :brand_id
      t.integer :price_cents
      t.integer :current_stock
      t.integer :minimum_stock
      t.integer :highlight_stock_from
      t.string :state

      t.timestamps
    end
  end
end
