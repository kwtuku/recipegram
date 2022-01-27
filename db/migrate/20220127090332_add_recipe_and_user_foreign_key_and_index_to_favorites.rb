class AddRecipeAndUserForeignKeyAndIndexToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :favorites, :recipes
    add_foreign_key :favorites, :users
    add_index :favorites, :recipe_id
    add_index :favorites, :user_id
  end
end
