class ChangeOrderPayment < ActiveRecord::Migration
  change_table :order_payments do |t|
      t.rename :id_adress, :ip_address
  end
end
