class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.all 
    @event = Event.find_by(id: params[:event_id]) 
    if @event.nil?
      redirect_to events_path, alert: 'イベントが見つかりませんでした。' 
      return
    end
    # イベントに紐づくアイテムを最初に取得
    @items = @event.items
    # 検索機能付き
    if params[:search].present?
      @items = @items.where('name LIKE ?', "%#{params[:search]}%")  # アイテム名で絞り込み
    end
   # ソート機能
   case params[:sort_by]
   when 'newest'
     @items = @items.order(created_at: :desc)  # 新着順
   when 'complete'
     @items = @items.where(status: '完了').order(created_at: :desc)  # 準備完了
   when 'incomplete'
     @items = @items.where(status: '未完了').order(created_at: :desc)  # 準備中
   else
     @items = @items.order(created_at: :desc)  # デフォルトで新着順
   end

    @items = @items.page(params[:page])  # ページネーションを適用
  end
  def show
    @item = Item.find(params[:id])  # アイテムを取得
    @event = @item.event            # アイテムに紐づくイベントを取得
  end
end
