class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :shop_id
      t.integer :driver_id
      t.datetime :go_at
      t.datetime :come_back
      t.integer :pass1_id
      t.integer :pass2_id
      t.integer :pass3_id
      t.integer :pass4_id
      t.boolean :cangodrive

      t.timestamps null: false
    end
  end
end
