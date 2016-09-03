class AddListnameToShop < ActiveRecord::Migration
  def change
    add_column :shops, :listname, :string
  end
end
