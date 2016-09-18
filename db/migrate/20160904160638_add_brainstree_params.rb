class AddBrainstreeParams < ActiveRecord::Migration
  def change
    add_column :users, :braintree_id, :string
    add_column :users, :braintree_mid, :string
    add_column :transactions, :braintree_tid, :string
    add_column :transactions, :braintree_status, :string
  end
end
