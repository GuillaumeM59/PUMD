class CreateTrajetpumds < ActiveRecord::Migration
  def change
    create_table :trajetpumds do |t|
      t.integer :driver_id, null: false
      t.integer :shop_id, null: false
      t.date :td_date, null: false
      t.time :td_time, null: false
      t.boolean :regulier, default: false


      t.timestamps null: false
    end
  end
end
