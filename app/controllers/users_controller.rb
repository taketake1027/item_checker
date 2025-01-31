class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:guest_login, :destroy] 
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
  @events = @user.events 
  @posts = @user.posts
  @comments = @user.comments
  @liked_posts = @user.liked_posts 
  @events = @user.events.page(params[:page]).per(5)
  @posts = @user.posts.page(params[:page]).per(5)
  @comments = @user.comments.page(params[:page]).per(5)
  @liked_posts = @user.liked_posts.page(params[:page]).per(5)
  end

  def edit
  end

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

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = current_user
  end
end
