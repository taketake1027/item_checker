class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:guest_login, :destroy] # 認証が必要なアクションを指定
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def show
    
  end
  # ユーザー情報の編集フォームを表示
  def edit
  end

  # ユーザー情報を更新
  def update
    # パスワードを空欄にした場合、パスワードの更新をスキップする
    p=user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      
      p.delete(:password)
      p.delete(:password_confirmation)
    end
    
    if @user.update(p)
      bypass_sign_in @user, scope: :user
      redirect_to mypage_path, notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end

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
