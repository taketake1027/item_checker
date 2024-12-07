module Admins
  class EventsController < ApplicationController
    before_action :authenticate_admin!

    def index
      @events = Event.includes(:group)
    end

    private

    def authenticate_admin!
      redirect_to root_path, alert: '権限がありません' unless current_user&.admins?
    end
  end
end
