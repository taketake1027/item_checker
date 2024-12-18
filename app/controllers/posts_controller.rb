class PostsController < ApplicationController
  before_action :set_event
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def create
    @event = Event.find(params[:event_id])
    @post = @event.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to event_path(@event), notice: '投稿が成功しました！'
    else
      render 'events/show'
    end
  end

  def show
    @event = Event.find(params[:id])
    @posts = @event.posts.includes(:user).order(created_at: :desc)
    logger.debug "Posts fetched: #{@posts.inspect}"  # ログ出力
  end
  
  def destroy
    if @post.user == current_user  # 投稿したユーザーだけが削除できる
      @post.destroy
      redirect_to event_path(@event), notice: '投稿が削除されました。'
    else
      redirect_to event_path(@event), alert: '削除権限がありません。'
    end
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
    params.require(:post).permit(:title, :content, :image)  # :file を追加
  end
end
