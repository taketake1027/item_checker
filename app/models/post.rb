class Post < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :comments, dependent: :destroy # コメントを関連付け
  has_one_attached :file
  validates :content, presence: true

  
end
