class UpdateUsers < ActiveRecord::Migration
  def change
      change_column :users, :subscribe,:boolean, :default => false
      add_column :users, :phone, :string
      add_column :users, :avatar, :string
      add_column :users, :adress, :string
      add_column :users, :zipcode, :string
      add_column :users, :city, :string
      add_column :users, :country, :string
      add_column :users, :xp, :integer
  end
end
