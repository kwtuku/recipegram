class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @feed_items = current_user.feed.order(updated_at: :DESC).first(20) if user_signed_in?
  end

  def search
    @q = Recipe.ransack(params[:q])
    @results = @q.result(distinct: true)
    @results_size = @results.size

    @user_q = User.ransack(params[:q])
    @user_results = @user_q.result(distinct: true)
    @user_results_size = @user_results.size

    @q_word = if @q.conditions.present?
                @q.conditions.first.values.first.value
              elsif @user_q.conditions.present?
                @user_q.conditions.first.values.first.value
              end

    @q_column = if request.query_string.include? 'title'
                  :title_has_every_term
                elsif request.query_string.include? 'body'
                  :body_has_every_term
                elsif request.query_string.include? 'username'
                  :username_has_every_term
                elsif request.query_string.include? 'profile'
                  :profile_has_every_term
                else
                  :title_has_every_term
                end
  end
end
