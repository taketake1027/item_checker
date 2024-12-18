class EventsController < ApplicationController
  before_action :authenticate_user!

  def show
    @event = Event.find(params[:id])
    @posts = @event.posts.page(params[:page]).per(4)
    
    
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
  
  private

  def post_params
    params.require(:post).permit(:content)
  end
end
