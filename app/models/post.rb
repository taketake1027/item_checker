class Post < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :comments, dependent: :destroy # コメントを関連付け
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user # 追加
   # バリデーションの追加
   validates :title, presence: true
  validates :content, presence: true
end
