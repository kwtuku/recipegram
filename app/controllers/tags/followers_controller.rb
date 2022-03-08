module Tags
  class FollowersController < ApplicationController
    def create
      @tag = Tag.find_by(name: params[:tag_name])
      current_user.tag_followings.find_or_create_by(tag_id: @tag.id)
    end

    def destroy
      @tag = Tag.find_by(name: params[:tag_name])
      current_user.tag_followings.find_by(tag_id: @tag.id)&.destroy
    end
  end
end
