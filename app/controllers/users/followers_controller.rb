module Users
  class FollowersController < ApplicationController
    def create
      @user = User.find_by!(username: params[:user_username])
      return unless current_user.follow(@user)

      relationship = current_user.relationships.find_by(follow_id: @user.id)
      Notification.create_relationship_notification(relationship)
    end

    def destroy
      @user = User.find_by!(username: params[:user_username])
      current_user.unfollow(@user)
    end
  end
end
