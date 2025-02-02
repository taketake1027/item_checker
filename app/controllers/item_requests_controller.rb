class ItemRequestsController < ApplicationController
  before_action :set_item, only: [:create, :destroy]
  
  def create
    @item_request = @item.item_requests.new(user: current_user, status: 'pending')

    if @item_request.save
      respond_to do |format|
        format.js { render 'create' }  # create.js.erb を実行
      end
    end
  end

  def destroy
    @item_request = @item.item_requests.find_by(user_id: current_user.id)

    if @item_request&.destroy
      respond_to do |format|
        format.js { render 'destroy' }  # destroy.js.erb を実行
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
