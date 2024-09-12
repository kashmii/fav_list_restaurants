require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  before do
    driven_by(:rack_test)
  end

  # ===== =====
  # section2
  describe 'ログイン後のユーザーの部屋作成／その後に関して' do
    context 'ログインしたのがroom_idを持たないユーザーの場合' do
      it "部屋を作成できる" do
        user = create(:user)
        sign_in user
        visit root_path
        # ログイン後の遷移先に、下記のボタンがある
        expect(page).to have_content '部屋作成へ'

        # 部屋を作成すると、その部屋のページに遷移する

        click_on '部屋作成へ'
        fill_in 'room[name]', with: 'おしゃれな居酒屋'
        click_button '部屋を作成する'
        expect(page).to have_text 'おしゃれな居酒屋'
      end
    end

    context 'ログインしたのがroom_idを持つユーザーの場合' do
      it "ログイン後に部屋の画面にいる" do
        room = create(:room, name: 'bbbbbb')
        user = create(:user, room_id: room.id)
        sign_in user
        visit root_path
        # ログイン後の遷移先に、下記のテキストがある
        expect(page).to have_text room.name
      end
    end
  end
    # section2ここまで
    # ===== =====
end