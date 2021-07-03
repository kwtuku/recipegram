class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @feed_items = current_user.feed.order(updated_at: :DESC).first(20) if user_signed_in?
  end

  def search
    @source = 'recipe_title'
    if params[:source].present?
      @source = params[:source].to_s
    end

    @q_value = params[:q]

    title_q = { title_has_every_term: @q_value, s: { '0' => { name: params[:sort], dir: params[:order] } } }
    body_q = { body_has_every_term: @q_value, s: { '0' => { name: params[:sort], dir: params[:order] } } }
    username_q = { username_has_every_term: @q_value }
    profile_q = { profile_has_every_term: @q_value }

    recipe_title_q = Recipe.ransack(title_q)
    recipe_body_q = Recipe.ransack(body_q)
    user_username_q = User.ransack(username_q)
    user_profile_q = User.ransack(profile_q)

    recipe_title_results = recipe_title_q.result
    recipe_body_results = recipe_body_q.result
    user_username_results = user_username_q.result
    user_profile_results = user_profile_q.result

    @recipe_title_results = recipe_title_results.page(params[:page]).per(10)
    @recipe_body_results = recipe_body_results.page(params[:page]).per(10)
    @user_username_results = user_username_results.page(params[:page]).per(10)
    @user_profile_results = user_profile_results.page(params[:page]).per(10)

    @recipe_title_results_size = recipe_title_results.size
    @recipe_body_results_size = recipe_body_results.size
    @user_username_results_size = user_username_results.size
    @user_profile_results_size = user_profile_results.size
  end
end
