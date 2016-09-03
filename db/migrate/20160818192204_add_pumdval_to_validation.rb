class AddPumdvalToValidation < ActiveRecord::Migration
  def change
    add_column :validations, :ispumdval, :boolean, default:false
  end
end
