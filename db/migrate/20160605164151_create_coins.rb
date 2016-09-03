class CreateCoins < ActiveRecord::Migration
  def change
    create_table :coins do |t|
      t.integer :user_id, default: 0
      t.string :bid_id, default: 0
      t.string :comment1
      t.string :comment2

      t.timestamps null: false
    end
  end
end
