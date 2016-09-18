class AddShopnameToTrajetpumd < ActiveRecord::Migration
  def change
    add_column :trajetpumds, :driver_uname, :string
    add_column :trajetpumds, :driver_lat, :float
    add_column :trajetpumds, :driver_lon, :float
    add_column :trajetpumds, :shop_name, :string
  end
end
