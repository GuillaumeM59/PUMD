class RenameCarbrandToCarmodel < ActiveRecord::Migration
  def change
    rename_column :carmodels, :brand_id, :carbrand_id
  end
end
