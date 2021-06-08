class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @feed_items = current_user.feed.order(updated_at: :DESC).first(20) if user_signed_in?
  end

  def search
    @q = Recipe.ransack(params[:q])
    @results = @q.result(distinct: true)
  end
end
