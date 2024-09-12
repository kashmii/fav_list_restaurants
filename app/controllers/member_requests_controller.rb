class MemberRequestsController < ApplicationController
  before_action :set_request, only: %i(allow deny)
  before_action :get_user, only: %i(allow deny create)

  def new
    if current_user.request_allowed == false
      redirect_to about_path, notice: 'メンバー申請できない状態です'
    end
  end

  def check
    if params[:room_token].blank?
      redirect_to new_member_request_path, notice: 'idが入力されていません' 
    else
      if current_user.request_allowed == true
        get_user
        @room = Room.find_by(token: params[:room_token])
        if @room.nil?
          redirect_to new_member_request_path, notice: 'idが間違っています'
        else
          @room_token = params[:room_token]
          @room_founder = User.find(@room.room_founder.founder_id)
        end
      end
    end
  end

  def create
    if params[:room_token].blank?
      redirect_to new_member_request_path, notice: 'idが入力されていません' 
    else
      @room = Room.find_by(token: params[:room_token])
      request = MemberRequest.new(room_id: @room.id, appricant_id: @user.id)
      MemberRequest.transaction do
        request.save!
        # 部屋製作者を取得してnotificationテーブルのvisited_idに設定する
        founder_id = RoomFounder.find_by(room_id: @room.id).founder_id
        room_founder = User.find(founder_id)
        room_founder.create_notification_member_request!(current_user, request)
        @user.update!(request_allowed: false)
        # flash出す
        redirect_to about_path, notice: 'メンバー申請しました'
      rescue
        redirect_to new_member_request_path, notice: 'エラーが発生しました'
      end
    end
  end

  def destroy
    get_user
    request = MemberRequest.find_by(appricant_id: @user.id)
    MemberRequest.transaction do
      request.destroy
      # 紐付いている通知を削除
      @user.destroy_notification_member_request!(current_user)
      # userのrequestフラグをtrueにする！
      @user.update!(request_allowed: true)

    end
    redirect_to about_path, notice: 'メンバー申請を取り消しました'
  end

  def allow
    @request.allowed!
    redirect_to notifications_path
  end

  def deny
    @request.denied!
    redirect_to notifications_path, notice: '接続を拒否しました'
  end

  private

    def get_user
      @user = current_user
    end

    def set_request
      @request = MemberRequest.find(params[:id])
    end
end
