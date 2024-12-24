class Admin::GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :add_user_to_group]

  def index
    @groups = Group.all

    if params[:search].present?
      @groups = Group.where('name LIKE ?', "%#{params[:search]}%").page(params[:page]).per(10)
    else
      @groups = Group.all.page(params[:page]).per(10)
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.creator_id = current_admin.id
  
    if @group.save
      redirect_to admin_groups_path, notice: 'グループが作成されました'
    else
      flash.now[:alert] = 'グループの作成に失敗しました。'
      Rails.logger.debug @group.errors.full_messages  # エラーメッセージをログで確認
      render :new
    end
  end
  

  def show
    @group_users = @group.group_users.includes(:user).page(params[:page]).per(3)
  end

  def update
    if @group.update(group_params)
      # 変更があった場合のみ「グループ情報が更新されました」のメッセージ
      if @group.saved_changes.empty?
        flash[:notice] = '変更はありませんでした。'
      else
        flash[:notice] = 'グループ情報が更新されました。'
      end
      redirect_to admin_group_path(@group)
    else
      flash.now[:alert] = 'グループ情報の更新に失敗しました。'
      render :edit
    end
  end
  
  def destroy
    @group.destroy
    redirect_to admin_groups_path, notice: 'グループが削除されました。'
  end

  # ユーザーをグループに追加
  def add_user_to_group
    email = params[:email]
    user = User.find_by(email: email)

    if user.blank?
      flash[:alert] = "指定されたメールアドレスのユーザーは存在しません。"
    elsif @group.group_users.exists?(user_id: user.id)
      flash[:alert] = "#{email}さんは既にこのグループに参加しています。"
    else
      group_user = @group.group_users.new(user_id: user.id, status: 'active', joined_date: Date.today)
      if group_user.save
        flash[:notice] = "#{email}さんをグループに追加しました。"
      else
        flash[:alert] = "#{email}さんをグループに追加できませんでした。"
      end
    end

    redirect_to admin_group_path(@group)
  end

  # グループからユーザーを削除
  def remove_user_from_group
    group_user = @group.group_users.find_by(user_id: params[:id])

    if group_user
      group_user.destroy
      flash[:notice] = 'ユーザーがグループから削除されました。'
    else
      flash[:alert] = '指定されたユーザーはこのグループに参加していません。'
    end

    redirect_to admin_group_path(@group)
  end

  private

  def set_group
    @group = Group.find_by(id: params[:id])
    unless @group
      redirect_to admin_groups_path, alert: 'グループが見つかりませんでした。'
    end
  end

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end
