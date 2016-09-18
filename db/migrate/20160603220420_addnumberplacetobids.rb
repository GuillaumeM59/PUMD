class Addnumberplacetobids < ActiveRecord::Migration
  def change
    add_column :bids, :withreturn, :boolean, default: true
    add_column :bids, :nbrplace, :integer, default:1
  end
end
