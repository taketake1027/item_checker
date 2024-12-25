class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!  # 管理者の認証を行う
  before_action :set_user, only: [:update_role, :destroy]

  # ユーザー一覧ページを表示
  def index
    @user = User.find_by(id: params[:id]) # find_byを使ってユーザーが存在しない場合はnilを返す

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
    @users = @users.page(params[:page]).per(5)  
  end

  def show
    @user = User.find(params[:id])
    @user_events = @user.events
    @user_groups = @user.groups

    @events = @user.events.page(params[:page]).per(2)
    @posts = @user.posts.page(params[:page]).per(2)
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

  # 役職の更新
  def update_role
    if @user.update(role: params[:user][:role])
      flash[:notice] = '役職が更新されました。'
      redirect_to admin_users_path
    else
      flash[:notice] = "役職の更新に失敗しました: #{@user.errors.full_messages.join(', ')}"
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :status, tag_ids: [])   # 必要なパラメータを許可
  end

  # 管理者のみアクセスできるように制限
  def authenticate_admin!
    redirect_to root_path, alert: '管理者専用ページです。' unless current_admin
  end

  def set_user
    @user = User.find_by(id: params[:id]) # find_byを使ってユーザーが存在しない場合はnilを返す
    unless @user
      redirect_to admin_users_path, alert: '指定されたユーザーは存在しません。'
    end
  end
end
