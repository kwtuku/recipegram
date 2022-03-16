class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @recipes = Recipe.order(id: :desc).page(params[:page]).without_count
  end

  def show
    @recipe = Recipe.find(params[:id])
    @other_recipes = @recipe.others(3)
    @comment = Comment.new
    @comments = @recipe.comments.preload(:user).order(:id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to recipe_path(@recipe), notice: 'レシピを投稿しました。'
    else
      @recipe.recipe_image.cache!(recipe_params[:recipe_image]) if recipe_params[:recipe_image]
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    authorize @recipe
  end

  def update
    @recipe = Recipe.find(params[:id])
    authorize @recipe
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe), notice: 'レシピを編集しました。'
    else
      @recipe.recipe_image.cache!(recipe_params[:recipe_image]) if recipe_params[:recipe_image]
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
    params.require(:recipe).permit(:title, :body, :recipe_image, :recipe_image_cache, :tag_list)
  end
end
