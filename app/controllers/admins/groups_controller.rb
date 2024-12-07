module Admins
  class GroupsController < ApplicationController
    before_action :authenticate_admin!

    def index
      @groups = Group.all
    end

    # 今後の拡張に備えてアクションを追加
    def new
      @group = Group.new
    end

    def create
      @group = Group.new(group_params)
      if @group.save
        redirect_to admins_groups_path, notice: 'グループを作成しました'
      else
        render :new
      end
    end

    def edit
      @group = Group.find(params[:id])
    end

    def update
      @group = Group.find(params[:id])
      if @group.update(group_params)
        redirect_to admins_groups_path, notice: 'グループを更新しました'
      else
        render :edit
      end
    end

    def destroy
      @group = Group.find(params[:id])
      @group.destroy
      redirect_to admins_groups_path, notice: 'グループを削除しました'
    end

    private

    def group_params
      params.require(:group).permit(:name, :description)
    end
  end
end
