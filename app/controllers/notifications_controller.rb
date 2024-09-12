class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.includes([:visitor]).page(params[:page]).per(10)
    @room = Room.find(current_user.room_id)
  end
end
