module Users
  class FollowingTagsController < ApplicationController
    def index
      @user = User.find_by!(username: params[:user_username])
      @tags = @user.following_tags
      @tagged_recipes_collection = @tags.map { |tag| [tag.name, Recipe.tagged_with(tag.name).limit(6)] }.to_h
    end
  end
end
