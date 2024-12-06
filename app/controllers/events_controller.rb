# app/controllers/events_controller.rb
class EventsController < ApplicationController
  before_action :authenticate_user!

  def show
    @event = Event.find(params[:id])
  end
  
  def join
    @event = Event.find(params[:id])
    current_user.events << @event # ユーザーとイベントを関連付ける
    redirect_to @event, notice: 'イベントに参加しました！'
  end
end
