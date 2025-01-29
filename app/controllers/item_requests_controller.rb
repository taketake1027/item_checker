class ItemRequestsController < ApplicationController
  before_action :set_item, only: [:create, :destroy]

  def create
    @item_request = @item.item_requests.create(user_id: current_user.id)
    redirect_to event_items_path(@item.event), notice: '準備申請が完了しました。'
  end

  def destroy
    @item_request = @item.item_requests.find_by(user_id: current_user.id)
    if @item_request
      @item_request.destroy
      redirect_to event_items_path(@item.event), notice: '準備申請を取り消しました。'
    else
      redirect_to event_items_path(@item.event), alert: '申請が見つかりませんでした。'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])  # params[:id] を使用
  end
end