class HomesController < ApplicationController
  before_action :authenticate_user!, only: [:top]  # トップページはログイン必須
  before_action :restrict_guest_access, except: [:top, :about]

  def top
    if params[:search].present?
      @events = Event.where('name LIKE ?', "%#{params[:search]}%")
      # 検索結果がない場合
      if @events.empty?
        flash.now[:alert] = '該当するイベントがありませんでした。'
      end
    else
      @events = Event.all
      flash.now[:alert] = '検索ワードを入力してください。' if params[:search].nil? || params[:search].empty?
    end
    @events = @events.order(start_date: :asc).page(params[:page]).per(6)
  end
  
  def landing
    if user_signed_in?
      redirect_to homes_top_path
    end
  end

  def about
    
  end

  def index
    @events = Event.page(params[:page]).per(6)
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
