class PostsController < ApplicationController
  before_action :set_event
  before_action :set_post, only: [:show, :edit, :update, :destroy]

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

  def destroy
    if @post.destroy
      flash[:notice] = "投稿が削除されました。"
    else
      flash[:alert] = "投稿の削除に失敗しました。"
    end
    redirect_to event_path(@event)
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  # Strong Parameters: 投稿内容とファイルのパラメータを許可
  def post_params
    params.require(:post).permit(:content, :file)  # :file を追加
  end
end
