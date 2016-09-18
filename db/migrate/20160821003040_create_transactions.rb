class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :user_id
      t.string :comment
      t.integer :trajetpumd_id

      t.timestamps null: false
    end
  end
end
