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
  
    # デフォルト: 開催予定のものを優先し、開催日が近い順で表示
    events = events.where.not(start_date: nil).order(Arel.sql("CASE WHEN start_date >= '#{current_time}' THEN 0 ELSE 1 END, start_date ASC"))
  
    # ソート条件の適用
    case params[:sort]
    when "newest"
      @events = events.reorder(created_at: :desc)  # 新しい順
    when "upcoming"
      @events = events.where("end_date >= ?", current_time) # 未来のイベントのみ
    when "past"
      @events = events.where("end_date < ?", current_time) # 過去のイベントのみ
    else
      @events = events  # デフォルト（開催予定のものを先にし、開催日が近い順）
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
