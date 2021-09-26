class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index show generate_username)

  def index
    @users = User.order(id: :DESC).first(40)
  end

  def show
    @user = User.find_by(username: params[:username])
    @recipes = @user.recipes.eager_load(:favorites, :comments).order(id: :DESC).limit(40)
    @followers_you_follow = @user.followers_you_follow(current_user) if user_signed_in?
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if user_params[:user_image]
      tmp_image = @user.user_image
      if @user.update(user_params)
        tmp_image.remove!
        redirect_to user_url(@user), notice: 'プロフィールを変更しました。'
      else
        render :edit
      end
    else
      if @user.update(user_params)
        redirect_to user_url(@user), notice: 'プロフィールを変更しました。'
      else
        render :edit
      end
    end
  end

  def followings
    @user = User.find_by(username: params[:user_username])
    @follows = @user.followings.eager_load(:followings).order('relationships.created_at desc').limit(40)
    render 'follows'
  end

  def followers
    @user = User.find_by(username: params[:user_username])
    @follows = @user.followers.eager_load(:followings).order('relationships.created_at desc').limit(40)
    render 'follows'
  end

  def comments
    @user = User.find_by(username: params[:user_username])
    @recipes = @user.commented_recipes.eager_load(:favorites, :comments).order('comments.created_at desc').limit(40)
    @followers_you_follow = @user.followers_you_follow(current_user)
    render 'show'
  end

  def favorites
    @user = User.find_by(username: params[:user_username])
    @recipes = @user.favored_recipes.eager_load(:favorites, :comments).order('favorites.created_at desc').limit(40)
    @followers_you_follow = @user.followers_you_follow(current_user)
    render 'show'
  end

  def generate_username
    @username = User.generate_username
  end

  private
    def user_params
      params.require(:user).permit(:username, :nickname, :profile, :user_image)
    end
end
