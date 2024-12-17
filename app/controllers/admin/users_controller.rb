class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!  # 管理者の認証を行う

  # ユーザー一覧ページを表示
  def index
    @users = User.all
    @users = User.where.not(email: 'guest@example.com')
    # 検索機能
    if params[:name].present?
      @users = @users.where('name LIKE ?', "%#{params[:name]}%")
    end
    if params[:email].present?
      @users = @users.where('email LIKE ?', "%#{params[:email]}%")
    end
    if params[:role].present?
      @users = @users.where(role: params[:role])
    end
    @users = @users.page(params[:page]).per(10)  # 1ページあたり10件表示
  end

  def show
    @user = User.find(params[:id])
    @user_events = @user.events
    @user_groups = @user.groups
  end
  
  # ユーザーを更新
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザー情報が更新されました。'
    else
      render :edit
    end
  end

  # ユーザーを削除
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザーが削除されました。'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :status, tag_ids: [])   # 必要なパラメータを許可
  end

  # 管理者のみアクセスできるように制限
  def authenticate_admin!
    redirect_to root_path, alert: '管理者専用ページです。' unless current_admin
  end
end
