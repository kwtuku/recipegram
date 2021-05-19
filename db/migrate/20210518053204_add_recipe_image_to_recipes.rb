class AddRecipeImageToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :recipe_image, :string
  end
end
