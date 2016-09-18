class AddDefaultValueToShowAttribute < ActiveRecord::Migration
  def up
  change_column :bids, :pass1_id, :integer
  change_column :bids, :pass2_id, :integer
  change_column :bids, :pass3_id, :integer
  change_column :bids, :pass4_id, :integer
end

def down
  change_column :bids, :pass1_id, :integer, default: nil
  change_column :bids, :pass2_id, :integer, default: nil
  change_column :bids, :pass3_id, :integer, default: nil
  change_column :bids, :pass4_id, :integer, default: nil

end
end
