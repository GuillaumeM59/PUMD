class AddColumnToBids < ActiveRecord::Migration
  def change
    add_column :bids, :home, :string
  end
end
