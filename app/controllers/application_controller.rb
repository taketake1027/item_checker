class ApplicationController < ActionController::Base
  # Deviseのヘルパーをインクルード
  helper :all
  before_action :configure_permitted_parameters, if: :devise_controller?
  # ゲストログイン処理
  def guest_login
    user = User.find_or_create_by(email: 'guest@example.com') do |user|
      user.password = SecureRandom.hex(10) 
      user.name = 'ゲストユーザー' 
    end
    sign_in user  # ゲストユーザーとしてログイン
    redirect_to homes_top_path, notice: 'ゲストユーザーとしてログインしました'
  end

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    if resource.guest?  
      homes_top_path  # ゲストユーザーもトップページにリダイレクト
    else
      homes_top_path  # 通常ユーザーもトップページにリダイレクト
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
