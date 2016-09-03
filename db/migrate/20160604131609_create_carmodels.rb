class CreateCarmodels < ActiveRecord::Migration
  def change
    create_table :carmodels do |t|
      t.integer :brand_id
      t.string :name

      t.timestamps null: false
    end
  end
end
