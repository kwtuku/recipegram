class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index show show_additionally)

  def index
    @recipes = Recipe.eager_load(:favorites, :comments).order(updated_at: :DESC).first(40)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @comment = current_user.comments.new
    @comments = @recipe.comments.eager_load(:user)
  end

  def show_additionally
    first = params[:itemsSize].to_i
    if params[:type].to_s == 'home_home'
      file_path = 'home/feed'
      last = first + 19
      items = current_user.feed.order(updated_at: :DESC)[first..last]
      local_value = 'feed'
    elsif params[:type].to_s == 'recipes_index'
      file_path = 'recipes/recipe'
      last = first + 39
      items = Recipe.eager_load(:favorites, :comments).order(updated_at: :DESC)[first..last]
      local_value = 'recipe'
    elsif params[:type].to_s == 'users_index'
      file_path = 'users/user'
      last = first + 39
      items = User.order(id: :DESC)[first..last]
      local_value = 'user'
    elsif params[:type].to_s == 'followings'
      file_path = 'users/user_list'
      user = User.find(params[:paramsId].to_i)
      last = first + 39
      items = user.followings[first..last]
      local_value = 'user'
    elsif params[:type].to_s == 'followers'
      file_path = 'users/user_list'
      user = User.find(params[:paramsId].to_i)
      last = first + 39
      items = user.followers[first..last]
      local_value = 'user'
    end
    @file_path = file_path
    @items = items
    @local_value = local_value
  end

  def new
    @recipe = current_user.recipes.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
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
