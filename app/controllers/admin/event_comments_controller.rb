class Admin::EventCommentsController < ApplicationController
  layout 'admin'
  before_action :set_event, only: [:index, :destroy]

  def index
    # イベントに紐づくコメント一覧を取得し、関連するユーザー情報を含める
    @comments = @event.comments.includes(:user).order(created_at: :desc)
  end

  def destroy
    @comment = @event.comments.find(params[:id])
    if @comment.destroy
      redirect_to admin_event_comments_path(@event), notice: 'コメントを削除しました。'
    else
      redirect_to admin_event_comments_path(@event), alert: 'コメントの削除に失敗しました。'
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
