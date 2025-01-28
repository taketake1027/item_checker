class Admin::HomesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def top
    @pending_requests = EventRequest.includes(:user, :event).where(status: :pending)
  end
end
