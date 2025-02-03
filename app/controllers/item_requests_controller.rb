class ItemRequestsController < ApplicationController
  before_action :set_item, only: [:create, :destroy]
  
  def create
    @item_request = @item.item_requests.find_or_initialize_by(user: current_user)
    @item_request.status = 'pending'  # ここで確実に 'pending' に変更
  
    if @item_request.save
      Rails.logger.debug "申請成功: #{@item_request.inspect}"  # デバッグ用
      respond_to do |format|
        format.js
      end
    else
      Rails.logger.debug "申請失敗: #{@item_request.errors.full_messages}"
      head :unprocessable_entity
    end
  end
  
  def destroy
    user_request = @item.item_requests.find_by(user_id: current_user.id)
    if user_request
      user_request.update(status: 'rejected') # ステータスを「rejected」に変更
      respond_to do |format|
        format.js   # create.js.erb や destroy.js.erb を実行するため
        format.html { redirect_to event_item_path(@item.event, @item), notice: '申請がキャンセルされました' }
      end
    else
      redirect_to event_item_path(@item.event, @item), alert: '申請が見つかりませんでした'
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
