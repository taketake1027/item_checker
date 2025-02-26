# app/controllers/admin/event_requests_controller.rb
class Admin::EventRequestsController < ApplicationController
  before_action :authenticate_admin! # 管理者認証用フィルタ
  before_action :set_event_request, only: [:approve, :reject]

  def approve
    @event_request.update(status: 'approved')
    redirect_to admin_homes_top_path, notice: 'イベント申請が承認されました。'
  end

  def reject
    @event_request.update(status: 'rejected')
    redirect_to admin_homes_top_path, notice: 'イベント申請が却下されました。'
  end

  private

  def set_event_request
    @event_request = EventRequest.find(params[:id])
  end
end
