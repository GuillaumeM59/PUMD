class ChangenameAdresstoShop < ActiveRecord::Migration
  def change
    rename_column :shops, :adress, :address
  end
end
