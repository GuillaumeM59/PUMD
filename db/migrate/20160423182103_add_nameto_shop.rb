class AddNametoShop < ActiveRecord::Migration
  def change
    add_column :shops, :name, :string
    rename_column :shops, :brand_id_id, :brand_id
  end
end
