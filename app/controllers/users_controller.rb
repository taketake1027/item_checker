class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:guest_login, :destroy] # 認証が必要なアクションを指定
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    # ユーザーが参加しているイベントを取得
  @events = @user.events  # ユーザーが参加しているイベント
  @posts = @user.posts    # ユーザーが作成した投稿

  @events = @user.events.page(params[:page]).per(5)  # 5件ずつ表示
  @posts = @user.posts.page(params[:page]).per(5)    # 5件ずつ表示
  end

  # ユーザー情報の編集フォームを表示
  def edit
  end

  # ユーザー情報を更新
  def update
    # パスワードを空欄にした場合、パスワードの更新をスキップする
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      # user_paramsで削除する
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  
    if @user.update(user_params)
      # 変更があった場合のみ「プロフィールが更新されました」のメッセージ
      if @user.saved_changes.empty?
        flash[:notice] = '変更はありませんでした。'
      else
        flash[:notice] = 'プロフィールが更新されました。'
      end
      bypass_sign_in @user, scope: :user
      redirect_to mypage_path
    else
      render :edit
    end
  end
  

  def destroy
    if current_user == @user || current_user.admin?  # 管理者の場合も削除可能
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
    # パスワードと確認パスワードが空でない場合のみ、パスワードを許可する
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # ユーザー情報を取得
  def set_user
    # マイページや編集ページでは、現在ログインしているユーザーを取得
    @user = current_user
  end
end
