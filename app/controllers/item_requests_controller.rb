class ItemRequestsController < ApplicationController
  before_action :set_item, only: [:create, :destroy]
  before_action :set_item_request, only: [:approve, :reject]

  def create
    @item_request = @item.item_requests.create(user_id: current_user.id)
    redirect_to event_items_path(@item.event), notice: '準備申請が完了しました。'
  end

  def destroy
    @item_request = @item.item_requests.find_by(user_id: current_user.id)
    if @item_request
      @item_request.destroy
      # アイテムリクエストが削除された後、関連するイベントページにリダイレクト
      redirect_to event_items_path(@item_request.item.event), notice: '準備申請を取り消しました。'
    else
      # 申請が見つからない場合、適切なメッセージを表示
      redirect_to event_items_path(@item.event), alert: '申請が見つかりませんでした。'
    end
  end

  def approve
    @item_request.update(status: 'approved')

    # 承認時に対応するアイテムの prepared_amount を増やす
    item = @item_request.item
    item.update(prepared_amount: item.prepared_amount + @item_request.requested_amount)

    # アイテムの承認後、対応するイベントページにリダイレクト
    redirect_to event_items_path(@item_request.item.event), notice: '準備申請を承認しました。'
  end

  def reject
    @item_request.update!(status: "rejected")
    # アイテムの却下後、イベントページにリダイレクト
    redirect_to event_items_path(@item_request.item.event), notice: '申請を却下しました'
  end

  private

  def set_item
    @item = Item.find(params[:id])  # アイテムIDはparams[:id]から取得
  end

  def set_item_request
    @item_request = ItemRequest.find(params[:id])  # リクエストIDはparams[:id]から取得
  end
end
