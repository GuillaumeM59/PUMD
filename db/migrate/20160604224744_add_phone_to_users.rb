class AddPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone2, :string
  end
end
