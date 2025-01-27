class Admin::CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  def destroy
    @comment.destroy
    redirect_to admin_event_posts_path(event_id: @comment.event.id), notice: 'コメントが削除されました。'
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_events_path, alert: '指定されたコメントは存在しません。'
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
