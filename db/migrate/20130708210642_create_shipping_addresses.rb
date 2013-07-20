class CreateShippingAddresses < ActiveRecord::Migration
  def change
    create_table :shipping_addresses do |t|
      t.integer :order_id
      t.string :reference_name
      t.string :reference_last_name
      t.string :company_name
      t.string :reference_phone
      t.integer :shipping_cost_id
      t.string :zip_code
      t.string :shipping_address_1
      t.string :shipping_address_2

      t.timestamps
    end
  end
end
