class ApplicationController < ActionController::Base
  # Deviseのヘルパーをインクルード
  helper :all

  # トップ、アバウト、ゲストログインは認証なしでアクセス
  #before_action :authenticate_user!, except: [:top, :about, :guest_login]

  # 管理者認証の追加
  #before_action :authenticate_admin!, if: :admin_controller?

  # DeviseのStrong Parameters設定
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ゲストログイン処理
  def guest_login
    user = User.find_or_create_by(email: 'guest@example.com') do |user|
      user.password = SecureRandom.hex(10)  # ゲスト用のランダムパスワードを設定
      user.name = 'ゲストユーザー'  # ゲストユーザーの名前を設定
    end
    sign_in user  # ゲストユーザーとしてログイン
    redirect_to homes_top_path, notice: 'ゲストユーザーとしてログインしました'  # トップページへリダイレクト
  end

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    if resource.guest?  # ゲストユーザーの場合
      homes_top_path  # ゲストユーザーもトップページにリダイレクト
    else
      homes_top_path  # 通常ユーザーもトップページにリダイレクト
    end
  end

  protected

  # Strong Parametersの設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  # 管理者用のコントローラかどうかを判定
  #def admin_controller?
  #  controller_name == 'admin/homes' || controller_name == 'admin/groups'
  #end

  # 管理者認証のメソッド
  #def authenticate_admin!
  #  unless current_admin
  #    redirect_to new_admin_session_path, alert: "管理者としてログインしてください。"
  #  end
  #end

  # 管理者がすでにログインしている場合は、ログインページにリダイレクトしない
  #def skip_authentication?
  #  controller_name == 'sessions' && action_name == 'new' && admin_signed_in?
  #end
end
