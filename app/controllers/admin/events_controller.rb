class Admin::EventsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_event, only: [:edit, :update]  # :edit と :update に set_event を追加

  def index
    if params[:search].present?
      @events = Event.where('name LIKE ?', "%#{params[:search]}%").page(params[:page])
    else
      @events = Event.page(params[:page])
    end
  end

  def new
    @event = Event.new
    @groups = Group.all
  end
  
  
  def create
    @event = Event.new(event_params)

    # 管理者がログインしていることを確認
    if current_admin.nil?
      redirect_to login_path, alert: '管理者としてログインしてください。'
      return
    end

    @event.user_id = current_admin.id  # 管理者IDを設定

    @groups = Group.all

    if @event.save
      redirect_to admin_events_path, notice: 'イベントが作成されました。'
    else
      render :new
    end
  end

  def edit
    @groups = Group.all
    # @add_membersを仮に設定 (add_members属性はEventモデルには存在しない)
    @add_members = 'group'  # 例: 'group' をデフォルトとして設定
  end

  def update
    if @event.update(event_params)
      redirect_to admin_events_path, notice: 'イベントが更新されました'
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

  def show
    # find_byを使って、イベントが見つからない場合にnilを返す
    @event = Event.find_by(id: params[:id])
    
    # イベントが見つからない場合にリダイレクト
    if @event.nil?
      redirect_to admin_events_path, alert: '指定されたイベントが見つかりません。'
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
