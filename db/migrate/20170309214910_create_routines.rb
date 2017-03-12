class CreateRoutines < ActiveRecord::Migration
  def change
    create_table :routines do |t|
      t.integer :driver_id
      t.integer :shop_id
      t.integer :day_num
      t.time :do_time
      t.integer :nsacs
      t.boolean :activated
      t.boolean :notif

      t.timestamps null: false
    end
  end
end
