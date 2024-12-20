# app/controllers/admin/posts_controller.rb
class Admin::PostsController < ApplicationController
  layout 'admin'
  def index
    @event = Event.find_by(id: params[:event_id])
    if @event
      @posts = @event.posts.page(params[:page]).per(4) 
  else
    @posts = []
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_event_posts_path(event_id: params[:event_id]), notice: '投稿を削除しました。'
  end
  
end
