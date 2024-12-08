class Admin::SessionsController < Devise::SessionsController
  layout 'admin'

  def new
  end

  #def create
    #super do |admin|
      # ログイン後にデバッグで確認
      #Rails.logger.debug("Admin signed in: #{admin_signed_in?}")
      
      #if admin_signed_in?
      #  redirect_to admin_homes_top_path and return
      #end
    #end
  #end

  private

  def after_sign_in_path_for(resource)
    admin_root_path
  end
  def after_sign_out_path_for(resource)
    admin_root_path
  end
end
