class AddCarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :driver, :boolean, default:false
    add_column :users, :cbrand_id, :integer
    add_column :users, :cmodel_id, :integer
    add_column :users, :carsize, :string, default:"M"
  end
end
