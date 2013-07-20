class CreateOrderPayments < ActiveRecord::Migration
  def change
    create_table :order_payments do |t|
      t.integer :order_id
      t.string :id_adress
      t.string :first_name
      t.string :last_name
      t.string :express_token
      t.string :express_payer_id

      t.timestamps
    end
  end
end
