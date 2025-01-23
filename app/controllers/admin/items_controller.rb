class Admin::ItemsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_item, only: [:show, :edit, :update]

  def index
    @items = Item.all

    if params[:event_id].present?
      @items = @items.where(event_id: params[:event_id])
    end

    # ステータスで並び替え
    case params[:sort_by]
    when 'newest'
      @items = @items.order(created_at: :desc)
    when 'incomplete'
      # 「在庫アリ」も「未完了」として扱う
      @items = @items.where(status: ['未完了', '在庫アリ']).order(prepared_amount: :asc)
    when 'complete'
      @items = @items.where(status: '完了').order(prepared_amount: :desc)
    end

    # ページネーション
    @items = @items.page(params[:page]).per(5)
  end

  def show
    # set_itemで@itemが設定されているので、特別な処理は不要
  end

  def new
    @item = Item.new
  end

  # アイテムの作成
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path, notice: 'アイテムが正常に作成されました。'
    else
      render :new
    end
  end

  def edit
    # set_itemで@itemが設定されているので、特別な処理は不要
  end

  # アイテムの情報を更新
  def update
    if @item.update(item_params)
      # 変更があった場合のみ「アイテムが更新されました」のメッセージ
      if @item.saved_changes.empty?
        flash[:notice] = '変更はありませんでした。'
      else
        flash[:notice] = 'アイテムが正常に更新されました。'
      end
      redirect_to admin_items_path
    else
      render :edit
    end
  end
  
  def destroy
    @item = Item.find_by(id: params[:id])
    if @item
      @item.destroy
      redirect_to admin_items_path, notice: 'アイテムが正常に削除されました。'
    else
      redirect_to admin_items_path, alert: 'アイテムが見つかりませんでした。'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
    unless @item
      redirect_to admin_items_path, alert: 'アイテムが見つかりませんでした。'
    end
  end
  
  def item_params
    params.require(:item).permit(:name, :introduction, :status, :amount, :prepared_amount, :event_id, :image)
  end
end
