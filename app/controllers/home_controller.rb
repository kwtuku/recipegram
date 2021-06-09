class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @feed_items = current_user.feed.order(updated_at: :DESC).first(20) if user_signed_in?
  end

  def search
    @q = Recipe.ransack(params[:q])
    @results = @q.result(distinct: true)

    @user_q = User.ransack(params[:q])
    @user_results = @user_q.result(distinct: true)

    @q_word = if @q.conditions.present?
                @q.conditions.first.values.first.value
              elsif @user_q.conditions.present?
                @user_q.conditions.first.values.first.value
              end
  end
end
