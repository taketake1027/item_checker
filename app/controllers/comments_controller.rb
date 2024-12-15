# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :set_event
  before_action :set_post

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to event_path(@event), notice: "コメントを投稿しました。"
    else
      redirect_to event_path(@event), alert: "コメントの投稿に失敗しました。"
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
end
