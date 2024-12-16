class Admin::ItemsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_item, only: [:show, :edit, :update]

  def index
    @items = Item.all

    if params[:search].present?
      @items = Item.where('name LIKE ?', "%#{params[:search]}%").page(params[:page]).per(10)
    else
      @items = Item.all.page(params[:page]).per(10)
    end
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
      redirect_to admin_items_path, notice: 'アイテムが正常に更新されました。'
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
    @item = Item.find_by(id: params[:id])
    unless @item
      redirect_to admin_items_path, alert: 'アイテムが見つかりませんでした。'
    end
  end
  
  # アイテムのパラメータをストロングパラメータで設定
  def item_params
    params.require(:item).permit(:name, :introduction, :status, :amount, :image)
  end
end
