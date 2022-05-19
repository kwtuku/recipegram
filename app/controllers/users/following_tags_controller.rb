module Users
  class FollowingTagsController < ApplicationController
    def index
      @user = User.find_by!(username: params[:user_username])
      @tags = @user.following_tags.preload(recipes: :first_image)
    end
  end
end
