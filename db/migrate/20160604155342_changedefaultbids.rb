class Changedefaultbids < ActiveRecord::Migration
  def change
    change_column_default(:bids, :withreturn, false)
  end
end
