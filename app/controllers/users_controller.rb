class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index show)

  def index
    @users = User.order(id: :DESC).first(40)
  end

  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.eager_load(:favorites, :comments).order(id: :DESC)
    @recipes_favorites_count = @user.recipes_favorites_count
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(@user), alert: '権限がありません。'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(@user), alert: '権限がありません。'
    elsif user_params[:user_image]
      tmp_image = @user.user_image
      if @user.update(user_params)
        tmp_image.remove!
        redirect_to user_path(@user), notice: 'プロフィールを変更しました。'
      else
        render :edit
      end
    else
      if @user.update(user_params)
        redirect_to user_path(@user), notice: 'プロフィールを変更しました。'
      else
        render :edit
      end
    end
  end

  def followings
    @user = User.find(params[:user_id])
    @follows = @user.followings.limit(40)
  end

  def followers
    @user = User.find(params[:user_id])
    @follows = @user.followers.limit(40)
    render 'followings'
  end

  def comments
    @user = User.find(params[:user_id])
    @recipes = @user.commented_recipes.eager_load(:favorites, :comments)
    @recipes_favorites_count = @user.recipes_favorites_count
    render 'show'
  end

  def favorites
    @user = User.find(params[:user_id])
    @recipes = @user.favored_recipes.eager_load(:favorites, :comments).order('favorites.created_at desc')
    @recipes_favorites_count = @user.recipes_favorites_count
    render 'show'
  end

  private
    def user_params
      params.require(:user).permit(:username, :profile, :profile_image, :user_image)
    end
end
