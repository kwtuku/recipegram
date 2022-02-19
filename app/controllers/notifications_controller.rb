class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.preload(notifiable: %i[recipe user]).order(id: :desc)
      .page(params[:page])
    @notifications.where(read: false).each do |notification|
      notification.update(read: true)
    end
  end
end
