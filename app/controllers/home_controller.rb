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

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def search
    @source = params[:source].to_s.presence || 'recipe_title'

    @q_value = params[:q]

    sort = { '0' => { name: params[:sort], dir: params[:order] } }

    title_query = { title_has_every_term: @q_value, s: sort }
    body_query = { body_has_every_term: @q_value, s: sort }
    nickname_query = { nickname_has_every_term: @q_value, s: sort }
    profile_query = { profile_has_every_term: @q_value, s: sort }
    name_query = { name_has_every_term: @q_value, taggings_count_gteq: '1' }

    recipe_title_results = Recipe.ransack(title_query).result.eager_load(:favorites, :comments, :tags, :tag_taggings)
    recipe_body_results = Recipe.ransack(body_query).result.eager_load(:favorites, :comments, :tags, :tag_taggings)
    user_nickname_results = User.ransack(nickname_query).result.eager_load(:recipes)
    user_profile_results = User.ransack(profile_query).result.eager_load(:recipes)
    tag_name_results = Tag.ransack(name_query).result

    @recipe_title_results = recipe_title_results.page(params[:page]).per(10)
    @recipe_body_results = recipe_body_results.page(params[:page]).per(10)
    @user_nickname_results = user_nickname_results.page(params[:page]).per(10)
    @user_profile_results = user_profile_results.page(params[:page]).per(10)
    @tag_name_results = tag_name_results.page(params[:page]).per(10)

    if @source == 'tag_name'
      @tagged_recipes = {}
      @tag_name_results.each do |tag|
        @tagged_recipes.store(tag.name, Recipe.tagged_with(tag.name).first(6))
      end
    end

    @result_counts = {
      title: recipe_title_results.size,
      body: recipe_body_results.size,
      nickname: user_nickname_results.size,
      profile: user_profile_results.size,
      name: tag_name_results.size
    }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
