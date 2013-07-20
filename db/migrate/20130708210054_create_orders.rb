class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :state
      t.datetime :purchased_at

      t.timestamps
    end
  end
end
