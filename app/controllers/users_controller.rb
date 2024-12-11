class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:guest_login, :destroy] # 認証が必要なアクションを指定
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # ユーザー削除
  def destroy
    if current_user == @user # 自分自身のアカウントのみ削除できるようにする
      @user.destroy
      sign_out @user # ユーザー削除後、サインアウト
      redirect_to new_user_registration_path, notice: 'アカウントが削除されました。'
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
