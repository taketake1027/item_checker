class ApplicationController < ActionController::Base
  # Deviseのヘルパーをインクルード
  helper :all

  # トップ、アバウト、ゲストログインは認証なしでアクセス
  before_action :authenticate_user!, except: [:top, :about, :guest_login]

  # DeviseのStrong Parameters設定
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ゲストログイン処理
  def guest_login
    user = User.find_or_create_by(email: 'guest@example.com') do |user|
      user.password = SecureRandom.hex(10)  # ゲスト用のランダムパスワードを設定
      user.name = 'ゲストユーザー'  # ゲストユーザーの名前を設定
    end
    sign_in user  # ゲストユーザーとしてログイン
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました'  # トップページへリダイレクト
  end

  protected

  # Strong Parametersの設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
