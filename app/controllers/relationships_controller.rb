class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:follow_id])
    return unless current_user.follow(@user)

    relationship = current_user.relationships.find_by(follow_id: @user.id)
    Notification.create_relationship_notification(relationship)
  end

  def destroy
    @user = User.find(params[:follow_id])
    current_user.unfollow(@user)
  end
end
