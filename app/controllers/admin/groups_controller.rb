# app/controllers/admin/groups_controller.rb
class Admin::GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!  # 管理者として認証

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
    if @group.save
      redirect_to admin_groups_path, notice: 'グループが作成されました'
    else
      render :new
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
