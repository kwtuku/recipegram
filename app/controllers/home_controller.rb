class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    if user_signed_in?
      @feeds = current_user.feed.preload(:user).order(id: :desc).limit(20)
      @recommended_users =
        Rails.cache.fetch("cache_recommended_users_#{current_user.id}", expires_in: 1.hour) do
          current_user.recommended_users(5)
        end
    else
      @feeds =
        Rails.cache.fetch('cache_recommended_recipes', expires_in: 1.hour) do
          Recipe.where(id: Recipe.select(:id).order('RANDOM()').limit(20)).preload(:user)
        end
      @recommended_users =
        Rails.cache.fetch('cache_recommended_users', expires_in: 1.hour) do
          User.where(id: User.select(:id).order('RANDOM()').limit(7))
        end
    end
  end

  def privacy; end

  def search
    @source = params[:source].to_s.presence || 'recipe_title'
    @q_value = params[:q]

    sort = { '0' => { name: params[:sort], dir: params[:order] } }

    results = {
      recipe_title: Recipe.ransack({ title_has_every_term: @q_value, s: sort }).result.preload(:tags, :tag_taggings),
      recipe_body: Recipe.ransack({ body_has_every_term: @q_value, s: sort }).result.preload(:tags, :tag_taggings),
      user_nickname: User.ransack({ nickname_has_every_term: @q_value, s: sort }).result,
      user_profile: User.ransack({ profile_has_every_term: @q_value, s: sort }).result,
      tag_name: Tag.ransack({ name_has_every_term: @q_value, taggings_count_gteq: '1', s: sort }).result
    }

    @results = results[@source.to_sym].page(params[:page])

    @result_counts = {
      title: results[:recipe_title].size,
      body: results[:recipe_body].size,
      nickname: results[:user_nickname].size,
      profile: results[:user_profile].size,
      name: results[:tag_name].size
    }

    return unless @source == 'tag_name'

    @tagged_recipes = {}
    @results.each do |tag|
      @tagged_recipes.store(tag.name, Recipe.tagged_with(tag.name).limit(6))
    end
  end
end
