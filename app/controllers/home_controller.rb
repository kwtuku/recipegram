class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    if user_signed_in?
      @feeds = current_user.home_recipes.first(20)
      @recommended_users = current_user.recommended_users.sample(5)
    else
      @feeds = Recipe.all.eager_load(:comments, :favorites, :user).sample(20)
      @recommended_users = User.all.sample(7)
    end
  end

  def privacy; end

  def search
    @source = params[:source].to_s.presence || 'recipe_title'
    @q_value = params[:q]

    sort = { '0' => { name: params[:sort], dir: params[:order] } }

    recipe_title_results = Recipe.ransack({ title_has_every_term: @q_value, s: sort }).result
      .eager_load(:favorites, :comments, :tags, :tag_taggings)
    recipe_body_results = Recipe.ransack({ body_has_every_term: @q_value, s: sort }).result
      .eager_load(:favorites, :comments, :tags, :tag_taggings)
    user_nickname_results = User.ransack({ nickname_has_every_term: @q_value, s: sort }).result.eager_load(:recipes)
    user_profile_results = User.ransack({ profile_has_every_term: @q_value, s: sort }).result.eager_load(:recipes)
    tag_name_results = Tag.ransack({ name_has_every_term: @q_value, taggings_count_gteq: '1', s: sort }).result

    @results = {
      recipe_title: recipe_title_results.page(params[:page]).per(10),
      recipe_body: recipe_body_results.page(params[:page]).per(10),
      user_nickname: user_nickname_results.page(params[:page]).per(10),
      user_profile: user_profile_results.page(params[:page]).per(10),
      tag_name: tag_name_results.page(params[:page]).per(10)
    }

    @result_counts = {
      title: recipe_title_results.size,
      body: recipe_body_results.size,
      nickname: user_nickname_results.size,
      profile: user_profile_results.size,
      name: tag_name_results.size
    }

    return unless @source == 'tag_name'

    @tagged_recipes = {}
    @results[:tag_name].each do |tag|
      @tagged_recipes.store(tag.name, Recipe.tagged_with(tag.name).first(6))
    end
  end
end
