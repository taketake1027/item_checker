class Post < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :comments, dependent: :destroy 
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user 
   
  validates :title, presence: true
  validates :content, presence: true
end
