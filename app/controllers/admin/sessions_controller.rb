class Admin::SessionsController < Devise::SessionsController
  def create
    super do |admin|
      # ログインが成功した場合、管理者専用ページにリダイレクト
      redirect_to admin_homes_top_path and return if admin.present?
    end
  end
end
