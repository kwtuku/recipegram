class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index show)

  def index
    @recipes = Recipe.preload(:favorites, :comments).order(updated_at: :DESC).first(40)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @comment = Comment.new
  end

  def show_additionally
    first = params[:recipesSize].to_i
    last = first + 39
    @recipes = Recipe.includes(:user).order(updated_at: :DESC)[first..last]
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    if @recipe.save
      redirect_to recipe_path(@recipe), notice: '投稿に成功しました。'
    else
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    if @recipe.user != current_user
      redirect_to recipe_path(@recipe), alert: '権限がありません。'
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe), notice: '更新に成功しました。'
    else
      render :edit
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path(@recipe)
  end

  private
    def recipe_params
      params.require(:recipe).permit(:title, :body, :image, :recipe_image)
    end
end
