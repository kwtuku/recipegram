class RelationshipsController < ApplicationController
  before_action :set_user

  def create
    following = current_user.follow(@user)
    if following.save
      flash[:notice] = @user.username + 'さんをフォローしました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = @user.username + 'さんのフォローに失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    following = current_user.unfollow(@user)
    if following.destroy
      flash[:notice] = @user.username + 'さんのフォローを解除しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = @user.username + 'さんのフォロー解除に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  private
    def set_user
      @user = User.find(params[:follow_id])
    end
end
