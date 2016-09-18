class CreateValidations < ActiveRecord::Migration
  def change
    create_table :validations do |t|
      t.integer :bid_id
      t.integer :driver_id
      t.integer :pass_id
      t.string :code
      t.boolean :validated, default: false
      t.date :bid_date

      t.timestamps null: false
    end
  end
end
