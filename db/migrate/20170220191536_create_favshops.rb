class CreateFavshops < ActiveRecord::Migration
  def change
    create_table :favshops do |t|
      t.integer :user_id, index: true, foreign_key: true
      t.integer :shop_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
