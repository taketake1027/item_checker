class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_event_access, only: [:show]

  def show
    @event = Event.find(params[:id])
    @posts = @event.posts.page(params[:page]).per(4)
    @post = Post.new  # 新規投稿用フォームを表示するために新しい投稿を作成
    @comment = Comment.new  # コメント用の新しいインスタンスを作成
  end
  
  def join
    @event = Event.find(params[:id])
    current_user.events << @event # ユーザーとイベントを関連付ける
    redirect_to @event, notice: 'イベントに参加しました！'
  end

  def create_post
    @event = Event.find(params[:event_id])  # イベントをIDで取得
    @post = @event.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to event_path(@event), notice: '投稿が成功しました！'
    else
      render :show, alert: '投稿に失敗しました。'
    end
  end
  
  def create_comment
    @post = Post.find(params[:post_id])  # 投稿をIDで取得
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to event_post_path(@post.event, @post), notice: 'コメントが投稿されました！'
    else
      redirect_to event_post_path(@post.event, @post), alert: 'コメントの投稿に失敗しました。'
    end
  end
  
  private

  def authorize_event_access
    @event = Event.find(params[:id])
  
    # イベントのグループに参加しているユーザーかどうかをチェック
    unless @event.group.users.exists?(id: current_user.id)
      flash[:alert] = "このイベントにはアクセスできません。"
      redirect_to homes_top_path
    end
  end
  
  def post_params
    params.require(:post).permit(:content)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
