class CommentsController < ApplicationController
  before_action :set_event
  before_action :set_post
  before_action :set_comment, only: [:destroy]
  # コメント削除
  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_to event_post_path(@event, @post), notice: 'コメントが削除されました。'
    else
      redirect_to event_post_path(@event, @post), alert: 'コメントを削除する権限がありません。'
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_post
    @post = @event.posts.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)  # コメント内容を許可
  end

  def set_comment
    @comment = Comment.find(params[:id])
    @event = Event.find(params[:event_id]) # イベントも必要な場合
  end
end
