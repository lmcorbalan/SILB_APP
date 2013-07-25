class AddTotalPriceCentsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_price_cents, :integer
  end
end
