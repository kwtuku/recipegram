class AddIndexToFavoritesRecipeIdAndUserId < ActiveRecord::Migration[6.1]
  def change
    add_index :favorites, [:recipe_id, :user_id], unique: true
  end
end
