class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_guest_access, except: [:top, :about]

  def top
  end

  def about
  end

  private

  def restrict_guest_access
    if guest_user?
      redirect_to root_path, alert: 'ゲストユーザーはこのページにアクセスできません。'
    end
  end
end
