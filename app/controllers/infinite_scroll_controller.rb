class InfiniteScrollController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(show)

  def show
    first = params[:itemsSize].to_i
    if params[:type].to_s == 'home_home'
      file_path = 'home/feed'
      last = first + 19
      items = current_user.feed.order(updated_at: :DESC)[first..last]
      local_value = 'feed'
    elsif params[:type].to_s == 'recipes_index'
      file_path = 'recipes/recipe'
      last = first + 39
      items = Recipe.eager_load(:favorites, :comments).order(updated_at: :DESC)[first..last]
      local_value = 'recipe'
    elsif params[:type].to_s == 'users_index'
      file_path = 'users/user'
      last = first + 39
      items = User.order(id: :DESC)[first..last]
      local_value = 'user'
    elsif params[:type].to_s == 'followings'
      file_path = 'users/follow'
      user = User.find(params[:paramsId].to_i)
      last = first + 39
      items = user.followings[first..last]
      local_value = 'user'
    elsif params[:type].to_s == 'followers'
      file_path = 'users/follow'
      user = User.find(params[:paramsId].to_i)
      last = first + 39
      items = user.followers[first..last]
      local_value = 'user'
    elsif params[:type].to_s == 'users_show'
      file_path = 'recipes/recipe'
      user = User.find(params[:paramsId].to_i)
      last = first + 39
      items = user.recipes.eager_load(:favorites, :comments).order(id: :DESC)[first..last]
      local_value = 'recipe'
    end
    @file_path = file_path
    @items = items
    @local_value = local_value
  end
end
