class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @recipes = Recipe.order(id: :desc).preload(:first_image).page(params[:page]).without_count
  end

  def show
    @recipe = Recipe.find(params[:id])
    @other_recipes = @recipe.others(3).preload(:first_image)
    @comment = Comment.new
    @comments = @recipe.comments.preload(:user).order(:id)
  end

  def new
    @recipe_form = RecipeForm.new
  end

  def create
    @recipe_form = RecipeForm.new(recipe_params, recipe: current_user.recipes.new)
    if @recipe_form.save
      redirect_to @recipe_form, notice: 'レシピを投稿しました。'
    else
      render :new
    end
  end

  def edit
    recipe = Recipe.find(params[:id])
    authorize recipe
    @recipe_form = RecipeForm.new(recipe: recipe)
  end

  def update
    recipe = Recipe.find(params[:id])
    authorize recipe
    @recipe_form = RecipeForm.new(recipe_params, recipe: recipe)
    if @recipe_form.save
      redirect_to @recipe_form, notice: 'レシピを編集しました。'
    else
      render :edit
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])
    authorize recipe
    recipe.destroy
    redirect_to recipes_url, notice: 'レシピを削除しました。'
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :body, :tag_list, image_attributes: %i[id resource position _destroy])
  end
end
