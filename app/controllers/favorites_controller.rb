class FavoritesController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @favorite = current_user.favorites.create(recipe_id: params[:recipe_id])
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @favorite = current_user.favorites.find_by(recipe_id: @recipe.id)
    @favorite.destroy
  end
end
