class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :category
      t.string :brandpic

      t.timestamps null: false
    end
  end
end
