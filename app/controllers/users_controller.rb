class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show generate_username]

  def index
    @users = User.order(id: :desc).limit(40)
  end

  def show
    @user = User.find_by!(username: params[:username])
    @recipes = @user.recipes.order(id: :desc).limit(40)
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
    elsif @user.update(user_params)
      redirect_to user_url(@user), notice: 'プロフィールを変更しました。'
    else
      render :edit
    end
  end

  def followings
    @user = User.find_by!(username: params[:user_username])
    @follows = @user.followings.order('relationships.id desc').limit(40)
    render 'follows'
  end

  def followers
    @user = User.find_by!(username: params[:user_username])
    @follows = @user.followers.order('relationships.id desc').limit(40)
    render 'follows'
  end

  def comments
    @user = User.find_by!(username: params[:user_username])
    @recipes = @user.commented_recipes.order('comments.id desc').limit(40)
    @followers_you_follow = @user.followers_you_follow(current_user)
    render 'show'
  end

  def favorites
    @user = User.find_by!(username: params[:user_username])
    @recipes = @user.favored_recipes.order('favorites.id desc').limit(40)
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
