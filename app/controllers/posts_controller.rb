# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  def create
    @event = Event.find(params[:event_id])  # イベントをIDで取得
    @post = @event.posts.build(post_params)  # イベントに紐づく新しい投稿を作成
    @post.user = current_user  # ユーザーを投稿に関連付け
  
    if @post.save
      redirect_to event_path(@event), notice: '投稿が成功しました！'
    else
      redirect_to event_path(@event), alert: '投稿に失敗しました。'
    end
  end
  

  private

  # Strong Parameters: 投稿内容のパラメータを許可
  def post_params
    params.require(:post).permit(:content)
  end
end
