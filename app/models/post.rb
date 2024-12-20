class Post < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :comments, dependent: :destroy # コメントを関連付け
  has_one_attached :image

   # バリデーションの追加
   validates :title, presence: true
  validates :content, presence: true
end
