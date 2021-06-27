class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.all.page(params[:page]).per(10)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
