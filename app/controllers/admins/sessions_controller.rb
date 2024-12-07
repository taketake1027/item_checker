class Admins::SessionsController < Devise::SessionsController
  before_action :authenticate_admin!  # 修正箇所

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end
end
