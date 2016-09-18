class CreateResapumds < ActiveRecord::Migration
  def change
    create_table :resapumds do |t|
      t.string :trajet_id, null: false
      t.string :drive1_ref
      t.string :drive2_ref
      t.string :drive3_ref
      t.string :drive4_ref
      t.string :drive5_ref
      t.string :drive6_ref
      t.integer :drive1_size
      t.integer :drive2_size
      t.integer :drive3_size
      t.integer :drive4_size
      t.integer :drive5_size
      t.integer :drive6_size
      t.integer :drive1_userid
      t.integer :drive2_userid
      t.integer :drive3_userid
      t.integer :drive4_userid
      t.integer :drive5_userid
      t.integer :drive6_userid

      t.timestamps null: false
    end
  end
end
