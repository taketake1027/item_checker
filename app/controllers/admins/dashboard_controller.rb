module Admins
  class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
      @groups_count = Group.count
      @events_count = Event.count
    end

    private

    def authenticate_admin!
      redirect_to root_path, alert: '権限がありません' unless current_user&.admins?
    end
  end
end
