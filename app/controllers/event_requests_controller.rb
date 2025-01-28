class EventRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_request, only: [:destroy]

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

  def destroy
    if @event_request.destroy
      redirect_to homes_top_path, notice: '参加申請が取り消されました。'
    else
      redirect_to homes_top_path, alert: '参加申請の取り消しに失敗しました。'
    end
  end

  private

  def set_event_request
    @event_request = current_user.event_requests.find_by(event_id: params[:event_id])
    # リクエストが見つからなければリダイレクト
    redirect_to homes_top_path, alert: 'リクエストが見つかりませんでした。' unless @event_request
  end
end
