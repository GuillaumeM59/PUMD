class AddBididToCoin < ActiveRecord::Migration
  def change
    add_column :coins, :bid_id, :integer, default: 0
  end
end
