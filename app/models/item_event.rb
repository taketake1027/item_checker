class ItemEvent < ApplicationRecord
  belongs_to :item
  belongs_to :event
end
