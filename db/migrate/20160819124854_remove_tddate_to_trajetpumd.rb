class RemoveTddateToTrajetpumd < ActiveRecord::Migration
  def change
    remove_column :trajetpumds, :td_date
    remove_column :trajetpumds, :td_time
    add_column :trajetpumds, :do_at, :datetime, null: false
    change_column_default :shops, :isdrive, false
  end
end
