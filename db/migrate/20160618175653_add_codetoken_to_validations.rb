class AddCodetokenToValidations < ActiveRecord::Migration
  def change
    add_column :validations, :code_token, :string, default: nil
  end
end
