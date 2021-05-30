class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.all
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
