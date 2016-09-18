class ChangetypeBididToCoin < ActiveRecord::Migration
  def change
    remove_column :coins, :bid_id
end
end
