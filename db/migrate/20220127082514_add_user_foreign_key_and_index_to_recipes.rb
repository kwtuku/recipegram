class AddUserForeignKeyAndIndexToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :recipes, :users
    add_index :recipes, :user_id
  end
end
