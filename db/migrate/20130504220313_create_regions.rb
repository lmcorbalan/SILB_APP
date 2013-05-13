class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.integer :country_id
      t.string :state

      t.timestamps
    end
  end
end
