class CreateShippingMethods < ActiveRecord::Migration
  def change
    create_table :shipping_methods do |t|
      t.string :name
      t.string :state

      t.timestamps
    end
  end
end
