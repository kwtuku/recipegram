class RemoveRecipeImageFromRecipes < ActiveRecord::Migration[6.1]
  def change
    remove_column :recipes, :recipe_image, :string
  end
end
