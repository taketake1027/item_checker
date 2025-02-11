class HomesController < ApplicationController
  before_action :authenticate_user!, only: [:top]  # トップページはログイン必須
  before_action :restrict_guest_access, except: [:top] # 検索ページはゲストアクセス制限

  def top
    # 検索機能
    if params[:search].present?
      events = Event.where('name LIKE ?', "%#{params[:search]}%")
    else
      events = Event.all
    end

    current_time = Time.current

    # デフォルト: 新しい順
    events = events.order(created_at: :desc)

    # ソート条件の適用
    case params[:sort]
    when "upcoming"
      @events = events.where("end_date >= ?", current_time)
    when "past"
      @events = events.where("end_date < ?", current_time)
    else
      @events = events  # デフォルト
    end

    # ページネーション
    @events = @events.page(params[:page]).per(6)
  end

  def landing
    redirect_to homes_top_path if user_signed_in?
  end

  private

  def guest_user?
    current_user && current_user.guest?
  end
  
  def restrict_guest_access
    if guest_user?
      redirect_to root_path, alert: 'ゲストユーザーはこのページにアクセスできません。'
    end
  end
end
