# app/controllers/admin/homes_controller.rb

class Admin::HomesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!  # 管理者認証を確認

  def top
    # トップページに特にデータを表示しない場合
  end
end
