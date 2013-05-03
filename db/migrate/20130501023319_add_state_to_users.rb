class AddStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :state, :string
    add_column :users, :activation_token, :string
  end
end
