class AddYearToCarmodel < ActiveRecord::Migration
  def change
    add_column :carmodels, :year, :integer
  end
end
