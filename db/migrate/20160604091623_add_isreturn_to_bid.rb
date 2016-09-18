class AddIsreturnToBid < ActiveRecord::Migration
  def change
    add_column :bids, :isreturn, :boolean, default: false
  end
end
