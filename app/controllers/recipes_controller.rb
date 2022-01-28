class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @recipes = Recipe.eager_load(:favorites, :comments).order(updated_at: :DESC).first(40)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @other_recipes = @recipe.others(3)
    @comment = Comment.new
    @comments = @recipe.comments.eager_load(:user).order(:id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to recipe_path(@recipe), notice: 'レシピを投稿しました。'
    else
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
    if recipe_params[:recipe_image]
      tmp_image = @recipe.recipe_image
      if @recipe.update(recipe_params)
        tmp_image.remove!
        redirect_to recipe_path(@recipe), notice: 'レシピを編集しました。'
      else
        render :edit
      end
    elsif @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe), notice: 'レシピを編集しました。'
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
    params.require(:recipe).permit(:title, :body, :recipe_image, :tag_list)
  end
end
