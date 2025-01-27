class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_user, only: [:update_role, :destroy]

  def index
    @users = User.where.not(email: 'guest@example.com') # ゲストユーザー除外
    if params[:name].present?
      @users = @users.where('name LIKE ?', "%#{params[:name]}%")
    end
    if params[:email].present?
      @users = @users.where('email LIKE ?', "%#{params[:email]}%")
    end
    if params[:role].present?
      @users = @users.where(role: params[:role])
    end

    @users = @users.page(params[:page]).per(4)
  end

  def show
    @user = User.find(params[:id])
    @user_events = @user.events
    @user_groups = @user.groups

    @events = @user.events.page(params[:page]).per(2)
    @posts = @user.posts.page(params[:page]).per(2)
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザー情報が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザーが削除されました。'
  end

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
    params.require(:user).permit(:name, :email, :role, :status, tag_ids: [])
  end

  def authenticate_admin!
    redirect_to root_path, alert: '管理者専用ページです。' unless current_admin
  end

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      redirect_to admin_users_path, alert: '指定されたユーザーは存在しません。'
    end
  end
end
