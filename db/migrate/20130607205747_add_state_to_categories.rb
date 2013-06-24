class AddStateToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :state, :string
  end
end
