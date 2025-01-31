class ItemRequestsController < ApplicationController
  before_action :set_item, only: [:create, :destroy]
  
  def create
  @item = Item.find(params[:item_id])  # アイテムを取得
  @user = current_user  # 現在のユーザーを取得
  # アイテム準備申請を作成
  @item_request = ItemRequest.create(item_id: @item.id, user_id: @user.id)
  respond_to do |format|
    format.js  # create.js.erb をレンダリング
    end
  end

  def destroy
    @item_request = @item.item_requests.find_by(user_id: current_user.id)
    if @item_request
      @item_request.destroy
      respond_to do |format|
        format.js # destroy.js.erb が呼ばれます
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def approve
    @item_request = ItemRequest.find(params[:id])
    if @item_request.update(status: 'approved')  # ステータスを 'approved' に更新
      # アイテムの準備数を増やす
      @item = @item_request.item
      @item.update(prepared_amount: @item.prepared_amount + 1)
  
      # アイテムが準備完了状態になったかを確認
      if @item.prepared_amount >= @item.amount
        @item.update(status: 'complete')  # アイテムのステータスを '準備完了' に更新
      end
    end
    
    # 処理後のリダイレクトまたはメッセージ表示
    redirect_to some_path, notice: '承認が完了しました'
  rescue => e
    # エラーハンドリング（必要に応じて）
    flash[:error] = "承認処理中にエラーが発生しました: #{e.message}"
    redirect_to some_error_path
  end
  

  private

  def set_item
    @item = Item.find(params[:item_id])  # `item_id` を使用
  end
end
