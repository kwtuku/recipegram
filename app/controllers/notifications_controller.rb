class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.preload(notifiable: %i[recipe user]).order(id: :desc)
      .page(params[:page]).per(20)
    @notifications.where(read: false).each { |notification| notification.update(read: true) }
  end
end
