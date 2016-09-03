class AddMinipicToBrand < ActiveRecord::Migration
  def change
      add_column :brands, :minipic, :string, default: nil
  end
end
