class ApplicationController < ActionController::Base
  # Deviseのヘルパーをインクルード
  helper :all

  # トップ、アバウト、ゲストログインは認証なしでアクセス
  before_action :authenticate_user!, except: [:top, :about, :guest_login]

  # ゲストログイン処理
  def guest_login
    user = User.find_or_create_by(email: 'guest@example.com') do |user|
      user.password = SecureRandom.hex(10)  # ゲスト用のランダムパスワードを設定
    end
    sign_in user  # ゲストユーザーとしてログイン
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました'  # トップページへリダイレクト
  end
end
