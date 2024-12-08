# app/controllers/admin/groups_controller.rb
class Admin::GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!  # 管理者として認証
  before_action :set_group, only: [:show, :edit, :update, :destroy] # 必要なアクションで@groupを設定

  def index
    @groups = Group.all  # グループの全データを取得
  end

  # 新規グループ作成ページ
  def new
    @group = Group.new
  end

  # グループ作成
  def create
    @group = Group.new(group_params)
    @group.creator_id = current_admin.id  # ログイン中の管理者IDをcreator_idに設定
    
    if @group.save
      redirect_to admin_groups_path, notice: 'グループが作成されました'
    else
      render :new
    end
  end

  def show
    # @group は before_action で設定済み
  end

  def update
    if @group.update(group_params)
      redirect_to admin_group_path(@group), notice: 'グループ情報が更新されました。'
    else
      flash.now[:alert] = 'グループ情報の更新に失敗しました。'
      render :edit
    end
  end

  private

  def set_group
    @group = Group.find_by(id: params[:id])
    unless @group
      redirect_to admin_groups_path, alert: 'グループが見つかりませんでした'
    end
  end

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end
