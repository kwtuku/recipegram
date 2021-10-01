class FavoritesController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    return unless current_user.favorites.create(recipe_id: @recipe.id)

    favorite = current_user.favorites.find_by(recipe_id: @recipe.id)
    Notification.create_favorite_notification(favorite)
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.find_by(recipe_id: @recipe.id)
    favorite.destroy
  end
end
