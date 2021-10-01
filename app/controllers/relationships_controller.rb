class RelationshipsController < ApplicationController
  before_action :set_user

  def create
    if relationship = current_user.follow(@user)
      Notification.create_relationship_notification(relationship)
    end
  end

  def destroy
    current_user.unfollow(@user)
  end

  private

  def set_user
    @user = User.find(params[:follow_id])
  end
end
