class AddBrandidtoBids < ActiveRecord::Migration
  def change
    add_column :bids, :brand_id, :string
  end
end
