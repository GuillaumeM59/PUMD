class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :user_id
      t.integer :carold
      t.string :carpic
      t.string :carbrand
      t.string :carmodel

      t.timestamps null: false
    end
  end
end
