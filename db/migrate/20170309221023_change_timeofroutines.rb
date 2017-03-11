class ChangeTimeofroutines < ActiveRecord::Migration
  def up
    change_column :routines, :do_time, :time
  end

  def down
    change_column :routines, :do_time, :datetime
  end
end
