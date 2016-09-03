class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.references :brand_id
      t.string :adress
      t.string :zipcode
      t.string :city
      t.boolean :isdrive

      t.timestamps null: false
    end
  end
end
