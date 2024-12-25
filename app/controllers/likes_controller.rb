class LikesController < ApplicationController
  before_action :set_event
  before_action :set_post

  def create
    if @post.likers.exclude?(current_user)
      @post.likes.create(user: current_user)
    end
    redirect_to event_path(@event, @post) 
  end

  def destroy
    like = @post.likes.find_by(user: current_user)
    like.destroy if like
    redirect_to event_path(@event, @post) 
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
