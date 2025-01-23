class Admin::EventsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_event, only: [:edit, :update]  

  def index
    @events = Event.all
    if params[:event_id].present?
      @events = Event.where(id: params[:event_id]).page(params[:page]).per(8) 
    else
      @events = Event.page(params[:page]).per(5)
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    if @event.nil?
      redirect_to admin_events_path, alert: '指定されたイベントが見つかりません。'
    end
  end

  def new
    @event = Event.new
    @groups = Group.all
  end
  
  
  def create
    @event = Event.new(event_params)
    if current_admin.nil?
      redirect_to login_path, alert: '管理者としてログインしてください。'
      return
    end

    @event.user_id = current_admin.id
    @groups = Group.all
    if @event.save
      redirect_to admin_events_path, notice: 'イベントが作成されました。'
    else
      render :new
    end
  end

  def posts
    @posts = @event.posts
  end

  def edit
    @event = Event.find(params[:id])
    @groups = Group.all

    @add_members = 'group'
  end

  def update
    if @event.update(event_params)
      if @event.saved_changes.empty?
        flash[:notice] = '変更はありませんでした。'
      else
        flash[:notice] = 'イベントが更新されました'
      end
      redirect_to admin_events_path
    else
      render :edit
    end
  end
  
  # イベント削除アクション
  def destroy
    @event = Event.find(params[:id])
    
    # イベントを削除
    if @event.destroy
      redirect_to admin_events_path, notice: 'イベントが削除されました。'
    else
      redirect_to admin_events_path, alert: 'イベント削除に失敗しました。'
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :introduction, :start_date, :end_date, :location, :group_id, :add_members, user_ids: [])
  end
end
