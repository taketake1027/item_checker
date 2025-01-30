class ItemRequestsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  
  def create
    @item_request = @event.item_requests.create(user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to event_items_path(@event), notice: '準備申請が完了しました。' }
      format.js   # JavaScriptテンプレート（非同期レスポンス）
    end
  end

  def destroy
    @item_request = @event.item_requests.find_by(user_id: current_user.id)
    if @item_request
      @item_request.destroy
    end
    respond_to do |format|
      format.html { redirect_to event_items_path(@event), notice: '準備申請を取り消しました。' }
      format.js   # JavaScriptテンプレート（非同期レスポンス）
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
