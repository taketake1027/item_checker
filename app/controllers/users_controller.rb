class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:guest_login] # 認証が必要なアクションを指定
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # ゲストログイン処理
  def guest_login
    user = User.find_or_create_by(email: 'guest@example.com') do |u|
      u.password = SecureRandom.urlsafe_base64
      u.name = "ゲストユーザー"
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  # マイページ表示
  def show
    # `set_user` メソッドで @user は既に設定されているので、ここで再度設定する必要はありません
  end

  # プロフィール編集
  def edit
  end

  # プロフィール更新
  def update
    if @user.update(user_params)
      # ゲストユーザーでない場合にのみ再ログインを行う
      sign_in @user, bypass: true unless @user.email == 'guest@example.com'
      redirect_to root_path, notice: 'プロフィールが更新されました！'
    else
      render :edit
    end
  end

  # ユーザー削除
  def destroy
    if current_user == @user # 自分自身のアカウントのみ削除できるようにする
      @user.destroy
      sign_out @user # ユーザー削除後、サインアウト
      redirect_to root_path, notice: 'アカウントが削除されました。'
    else
      redirect_to root_path, alert: '他のユーザーのアカウントは削除できません。'
    end
  end

  private

  # Strong Parameters
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # ユーザー情報を取得
  def set_user
    @user = current_user
  end
end
