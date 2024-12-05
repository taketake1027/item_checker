class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]  # showアクションには認証を追加

  # ゲストログイン処理
  def guest_login
    user = User.find_or_create_by(email: 'guest@example.com') do |u|
      u.password = SecureRandom.urlsafe_base64
      u.name = "ゲストユーザー"  # 必要に応じて他の属性も設定
    end
    sign_in user  # ゲストユーザーとしてサインイン
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  # ユーザーのマイページ表示
  def show
    @user = current_user  # 現在ログインしているユーザーの情報を取得
  end
end
