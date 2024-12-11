class Admin::GroupUsersController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    @group = Group.find(params[:group_id])
    @user = User.find(params[:id])
    @group.users.delete(@user)  # ユーザーをグループから削除

    redirect_to admin_group_path(@group), notice: 'ユーザーが削除されました。'
  end
end
