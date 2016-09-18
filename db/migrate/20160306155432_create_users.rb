class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.boolean :admin, default: false
      t.string :nom
      t.string :prenom
      t.text :comment
      t.boolean :subscribe, default: true

      t.timestamps null: false
    end
  end
end
