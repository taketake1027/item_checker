class Admin::HomesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def top
    @pending_requests = EventRequest.pending
    @pending_item_requests = ItemRequest.where(status: 'pending')
  end
end
