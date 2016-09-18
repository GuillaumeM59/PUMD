class AddUseridToTransactions < ActiveRecord::Migration
  def change
    change_column :transactions, :user_id, :integer
    add_column :transactions, :tvalue, :float
  end
end
