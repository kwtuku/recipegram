class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    if user_signed_in?
      @feeds = current_user.feed.order(id: :desc).preload(:first_image, :user).page(params[:page]).per(20).without_count
      @recommended_users = current_user.recommended_users(5).preload(:followers)
    else
      @feeds = Recipe.order('RANDOM()').preload(:first_image, :user).page(params[:page]).per(20).without_count
      @recommended_users =
        Rails.cache.fetch('cache_recommended_users', expires_in: 1.hour) do
          User.where(id: User.select(:id).order('RANDOM()').limit(7))
        end
    end
  end

  def privacy; end

  def search
    @source = params[:source] || 'recipe_title'
    @q_value = params[:q]

    sort = { '0' => { name: params[:sort], dir: params[:order] } }

    results = {
      recipe_title: Recipe.ransack({ title_has_every_term: @q_value, s: sort }).result
        .preload(:first_image, :tags, :tag_taggings),
      recipe_body: Recipe.ransack({ body_has_every_term: @q_value, s: sort })
        .result.preload(:first_image, :tags, :tag_taggings),
      user_nickname: User.ransack({ nickname_has_every_term: @q_value, s: sort }).result,
      user_profile: User.ransack({ profile_has_every_term: @q_value, s: sort }).result,
      tag_name: Tag.ransack({ name_has_every_term: @q_value, taggings_count_gteq: '1', s: sort }).result
        .preload(recipes: :first_image)
    }

    @results = results[@source.to_sym].page(params[:page]).per(20)

    @result_counts = {
      title: results[:recipe_title].size,
      body: results[:recipe_body].size,
      nickname: results[:user_nickname].size,
      profile: results[:user_profile].size,
      name: results[:tag_name].size
    }
  end
end
