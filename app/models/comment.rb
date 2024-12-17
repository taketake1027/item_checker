class Comment < ApplicationRecord
  belongs_to :post  
  belongs_to :user  
  belongs_to :event
  
  validates :body, presence: true  
end
