class PostsController < ApplicationController
  before_action :set_event
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def create
    @post = @event.posts.build(post_params)
    @post.user = current_user  # 現在のユーザーを関連付ける

    if @post.save
      redirect_to event_path(@event), notice: '投稿が作成されました。'
    else
      @posts = @event.posts.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
      redirect_to event_path(@event), alert: '投稿を作成できませんでした。必要な情報を入力してください。'
    end
  end

  def show
    @event = Event.find(params[:event_id])
    @post = @event.posts.find(params[:id])
    @posts = @event.posts.includes(:user).order(created_at: :desc)
  
    # コメントとコメントのユーザーを関連付けてページネーションを適用
    @comments = @post.comments.includes(:user).page(params[:page]).per(4)
    @comment = Comment.new
  end
  
  def create_comment
    @post = Post.find(params[:id])
    @event = Event.find(params[:event_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.event_id = @event.id
  
    if @comment.save
      redirect_to event_post_path(@event, @post), notice: "コメントを投稿しました。"
    else
      @comments = @post.comments.page(params[:page]).per(4).includes(:user)
      redirect_to event_post_path(@event, @post), alert: 'コメント内容を入力してください'
      #render :show
    end
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
    redirect_to root_path, alert: "Event not found" if @event.nil?
  end

  def set_post
    @post = Post.find(params[:id])
  end

  # Strong Parameters: 投稿内容とファイルのパラメータを許可
  def post_params
    params.require(:post).permit(:title, :content, :image)  # :file を追加
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
