class HomesController < ApplicationController
  before_action :authenticate_user!, only: [:top]  # トップページはログイン必須
  before_action :restrict_guest_access, except: [:top, :about]

  def top
    # 検索条件がある場合に検索を適用
    if params[:search].present?
      @events = Event.where('name LIKE ?', "%#{params[:search]}%")
    else
      @events = Event.all
    end
    
    # 検索後にページネーションを適用
    @events = @events.order(start_date: :asc).page(params[:page]).per(6)
  end
  
  def landing
    if user_signed_in?
      redirect_to homes_top_path
    end
  end

  def about
    # Aboutページの処理
  end

  def index
    @events = Event.page(params[:page]).per(6)
  end

  private

  def guest_user?
    current_user && current_user.guest?  # current_user がゲストユーザーかどうかを判定
  end
  
  def restrict_guest_access
    if guest_user?
      redirect_to root_path, alert: 'ゲストユーザーはこのページにアクセスできません。'
    end
  end
end
