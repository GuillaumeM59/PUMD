class ChangeTimeofroutines2 < ActiveRecord::Migration
  def change
    remove_column :routines, :do_time
    add_column :routines, :at_time, :string
  end
end
