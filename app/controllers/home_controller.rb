class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @feed_items = current_user.feed if user_signed_in?
  end
end
