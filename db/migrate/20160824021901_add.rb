class Add < ActiveRecord::Migration
  def change
      add_column :resapumds, :driver1_subst, :boolean
      add_column :resapumds, :driver2_subst, :boolean
      add_column :resapumds, :driver3_subst, :boolean
      add_column :resapumds, :driver4_subst, :boolean
      add_column :resapumds, :driver5_subst, :boolean
      add_column :resapumds, :driver6_subst, :boolean
      add_column :resapumds, :maxsac, :integer
  end
end
