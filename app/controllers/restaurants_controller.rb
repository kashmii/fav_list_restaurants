class RestaurantsController < ApplicationController
  before_action :set_room, only: [:index, :show, :create, :update]

  def index
    redirect_to new_restaurant_path(@room.token)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @reports = @restaurant.reports.eager_load(:writer)
  end

  def new
    if !user_signed_in?
      session[:previous_url] = request.url
      redirect_to about_path
    else
      user = current_user
      @room = Room.find_by(id: user.room_id)
    end
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.room_id = current_user.room_id
    @restaurant.last_editor_id = current_user.id
    if @restaurant.valid?
        @restaurant.save!
        redirect_to room_path(@room)
    else
      render :new
    end
  end

  def destroy
  end

  private

  def set_room
    if !user_signed_in?
      session[:previous_url] = request.url
      redirect_to about_path
    else
      user = current_user
      @room = Room.find_by(id: user.room_id)
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(
      :name,
      :genre,
      :place,
      :holiday,
      :url,
      :tel,
      {images: []}
    )
  end
end
