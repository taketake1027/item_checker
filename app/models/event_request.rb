class EventRequest < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum status: { pending: 0, approved: 1, rejected: 2 }
end
