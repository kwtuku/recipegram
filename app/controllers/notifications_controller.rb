class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.includes(notifiable: :user).all.page(params[:page]).per(10)
    @notifications.where(read: false).each do |notification|
      notification.update(read: true)
    end
  end
end
