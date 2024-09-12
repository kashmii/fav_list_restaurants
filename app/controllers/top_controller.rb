# rootのコントローラ
class TopController < ApplicationController
  before_action :set_user, :set_app_title
  before_action :set_answer_notification, only: :index

  def index
    # ログインしていて、部屋作成済み：部屋画面へ
    if user_signed_in? && @user.room_id.present?
      @room = Room.find(@user.room_id)
      # 入室申請に返事が来ているときにアラートを表示する
      if @answer_notification.present?
        flash[:notice] = '申請がOKされました。room名をお楽しみください！'
        @answer_notification.update!(checked: true)
      end
      redirect_to room_url(token: @room.token)
    else
      # 入室申請に返事が来ているときにアラートを表示する
      if @answer_notification.present?
        flash[:notice] = '入室は断られました。'
        @answer_notification.update!(checked: true)
      end
    end
  end

  def about
    # リクエスト申請済だったら、ビューにmember_requestsの変数を渡す
    if @user.present? && @user.request_allowed == false
      @member_requests = MemberRequest.find_by(appricant_id: @user.id)
    end
  end

  private

    def set_user
      @user = current_user
    end

    def set_answer_notification
      if @user.present?
        @answer_notification = Notification.find_by(
          action: 'request_answer',
          visited_id: @user.id,
          checked: false
        )
      end
    end
end
