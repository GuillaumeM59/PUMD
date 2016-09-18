class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :prenom
      t.string :email
      t.string :objet
      t.text :contenu

      t.timestamps null: false
    end
  end
end
