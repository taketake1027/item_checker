class HomesController < ApplicationController
  before_action :authenticate_user!, only: [:top]  # トップページはログイン必須
  before_action :restrict_guest_access, except: [:top, :about]

  def top
    @events = Event.all.order(start_date: :asc) # イベントを取得して開始日順に並べる
  end

  def about
    # Aboutページの処理
  end

  def index
    
  end
  private

  def restrict_guest_access
    if guest_user?
      redirect_to root_path, alert: 'ゲストユーザーはこのページにアクセスできません。'
    end
  end
end
