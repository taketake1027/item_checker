# app/models/item_request.rb
class ItemRequest < ApplicationRecord
  belongs_to :user
  belongs_to :item
  belongs_to :event
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :user, presence: true
  validates :item, presence: true
  validates :status, inclusion: { in: %w[pending approved rejected] }
end
