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

    title_q = { title_has_every_term: params[:q] }
    body_q = { body_has_every_term: params[:q] }
    username_q = { username_has_every_term: params[:q] }
    profile_q = { profile_has_every_term: params[:q] }

    recipe_title_q = Recipe.ransack(title_q)
    recipe_body_q = Recipe.ransack(body_q)
    user_username_q = User.ransack(username_q)
    user_profile_q = User.ransack(profile_q)

    @recipe_title_results = recipe_title_q.result(distinct: true)
    @recipe_body_results = recipe_body_q.result(distinct: true)
    @user_username_results = user_username_q.result(distinct: true)
    @user_profile_results = user_profile_q.result(distinct: true)

    @recipe_title_results_size = @recipe_title_results.size
    @recipe_body_results_size = @recipe_body_results.size
    @user_username_results_size = @user_username_results.size
    @user_profile_results_size = @user_profile_results.size

    recipe_size = Recipe.count
    user_size = User.count
    if @recipe_title_results_size == recipe_size || @recipe_body_results_size == recipe_size ||
        @user_username_results_size == user_size || @user_profile_results_size == user_size
      @too_much_results = true
    end

    @q_value = if recipe_title_q.conditions.present?
                recipe_title_q.conditions.first.values.first.value
              elsif recipe_body_q.conditions.present?
                recipe_body_q.conditions.first.values.first.value
              elsif user_username_q.conditions.present?
                user_username_q.conditions.first.values.first.value
              elsif user_profile_q.conditions.present?
                user_profile_q.conditions.first.values.first.value
              end
  end
end
