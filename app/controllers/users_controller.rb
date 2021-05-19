class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @recipes_favorites_count = 0
    @recipes.each do |recipe|
      @recipes_favorites_count += recipe.favorites.size
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(@user), alert: '権限がありません。'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: '更新に成功しました。'
    else
      render :edit
    end
  end

  def followings
    @user = User.find(params[:user_id])
    @followings = @user.followings
  end

  def followers
    @user = User.find(params[:user_id])
    @followers = @user.followers
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :profile, :profile_image, :user_image)
    end
end
