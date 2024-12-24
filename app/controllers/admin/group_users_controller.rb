class Admin::GroupUsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_group_user, only: [:destroy]

   # ユーザー削除
  def destroy
    if @group_user.destroy
      flash[:notice] = "ユーザーが削除されました"
    else
      flash[:alert] = "ユーザー削除に失敗しました"
    end
    redirect_to admin_group_path(@group_user.group)
  end

  private

  def set_group_user
    @group_user = GroupUser.find(params[:id])
  end
end
