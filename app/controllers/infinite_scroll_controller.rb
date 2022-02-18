class InfiniteScrollController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    first = params[:displayed_item_count].to_i
    path_components = params[:path].split('/')
    controller_name = path_components[0]
    username = path_components[1]
    action_name = path_components[2]

    file_path = 'recipes/recipe'
    local_value = 'recipe'
    @max_added_item_size = controller_name.nil? ? 20 : 40
    last = first + @max_added_item_size - 1
    user = User.find_by(username: username) if username

    if controller_name == 'recipes'
      added_items = Recipe.order(updated_at: :DESC)[first..last]
    elsif controller_name == 'tags'
      decoded_tag_name = URI.decode_www_form_component(path_components[1])
      added_items = Recipe.tagged_with(decoded_tag_name).order(id: :DESC)[first..last]
    elsif controller_name == 'users' && action_name == 'comments'
      added_items = user.commented_recipes.eager_load(:comments).order('comments.created_at desc')[first..last]
    elsif controller_name == 'users' && action_name == 'favorites'
      added_items = user.favored_recipes.order('favorites.created_at desc')[first..last]
    elsif controller_name == 'users' && username && action_name.nil?
      added_items = user.recipes.order(id: :DESC)[first..last]
    elsif controller_name == 'users' && username.nil?
      file_path = 'users/user'
      local_value = 'user'
      added_items = User.order(id: :DESC)[first..last]
    elsif controller_name == 'users' && username && action_name == 'followers'
      file_path = 'users/follow'
      local_value = 'user'
      added_items = user.followers.eager_load(:followings).order('relationships.created_at desc')[first..last]
    elsif controller_name == 'users' && username && action_name == 'followings'
      file_path = 'users/follow'
      local_value = 'user'
      added_items = user.followings.eager_load(:followings).order('relationships.created_at desc')[first..last]
    else
      last = first + 19
      file_path = 'home/feed'
      local_value = 'feed'
      added_items =
        if user_signed_in?
          current_user.home_recipes[first..last]
        else
          Recipe.where(id: Recipe.select(:id).order('RANDOM()').limit(20)).preload(:user)
        end
    end

    @file_path = file_path
    @added_items = added_items
    @local_value = local_value
  end
end
