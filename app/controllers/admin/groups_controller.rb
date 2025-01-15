class Admin::GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :add_user_to_group]

  def index
    @groups = Group.all

    if params[:search].present?
      @groups = Group.where('name LIKE ?', "%#{params[:search]}%").page(params[:page]).per(8)
    else
      @groups = Group.all.page(params[:page]).per(6)
    end
  end

  def new
    @group = Group.new
    @users = User.page(params[:page]).per(10)
  end

  def create
    @group = Group.new(group_params)
    @group.creator_id = current_admin.id
  
    if @group.save
      # 選ばれたユーザーが存在すれば、グループに追加
      if params[:group][:user_ids].present?
        # 空の値を除外
        user_ids = params[:group][:user_ids].reject(&:blank?)
  
        user_ids.each do |user_id|
          # group_users に追加
          @group.group_users.create(user_id: user_id, status: 'active', joined_date: Date.today)
        end
      end
      redirect_to admin_groups_path, notice: 'グループが作成されました'
    else
      flash.now[:alert] = 'グループの作成に失敗しました。'
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

  def add_user_to_group
    email = params[:email]
    user = User.find_by(email: email)
  
    if user.blank?
      flash[:alert] = "指定されたメールアドレスのユーザーは存在しません。"
    elsif @group.group_users.exists?(user_id: user.id)
      flash[:alert] = "#{email}さんは既にこのグループに参加しています。"
    else
      # `joined_date` を設定
      group_user = @group.group_users.new(user_id: user.id, status: 'active', joined_date: Date.today)
      if group_user.save
        flash[:notice] = "#{email}さんをグループに追加しました。"
      else
        flash[:alert] = "#{email}さんをグループに追加できませんでした。"
      end
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
