class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :region
      t.string :departement
      t.string :zip
      t.string :name

      t.timestamps null: false
    end
  end
end
