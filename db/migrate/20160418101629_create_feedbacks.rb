class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :bid_id
      t.integer :driver_id
      t.integer :pass_id
      t.integer :score
      t.text :comment

      t.timestamps null: false
    end
  end
end
