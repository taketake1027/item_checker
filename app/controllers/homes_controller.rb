class HomesController < ApplicationController
  before_action :authenticate_user!, only: [:top]  # トップページはログイン必須
  before_action :restrict_guest_access, except: [:top, :about]

  def top
    @events = Event.order(start_date: :asc).page(params[:page]).per(6) # ページネーションを適用
  end
  

  def about
    # Aboutページの処理
  end

  def index
    @events = Event.page(params[:page]).per(6)
  end
  private

  def restrict_guest_access
    if guest_user?
      redirect_to root_path, alert: 'ゲストユーザーはこのページにアクセスできません。'
    end
  end
end
