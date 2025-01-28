class EventRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    event_request = current_user.event_requests.build(event: @event, status: "pending")

    if event_request.save
      flash[:notice] = "イベントへの参加申請を送信しました。"
    else
      flash[:alert] = "参加申請に失敗しました。"
    end
    redirect_to homes_top_path
  end
end
