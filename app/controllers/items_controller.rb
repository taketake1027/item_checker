class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.all # すべてのイベントを取得
    # イベントの取得。params[:event_id]が必須。
    @event = Event.find_by(id: params[:event_id])  # find_byでnilチェック
    if @event.nil?
      redirect_to events_path, alert: 'イベントが見つかりませんでした。' # イベントが存在しない場合の処理
      return
    end

    # イベントに紐づくアイテムを最初に取得
    @items = @event.items

    # 検索機能付き
    if params[:search].present?
      @items = @items.where('name LIKE ?', "%#{params[:search]}%")  # アイテム名で絞り込み
    end

    @items = @items.page(params[:page])  # ページネーションを適用
  end
  def show
    @item = Item.find(params[:id])  # アイテムを取得
    @event = @item.event            # アイテムに紐づくイベントを取得
  end
end