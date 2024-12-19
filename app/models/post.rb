class Post < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :comments, dependent: :destroy # コメントを関連付け
  has_one_attached :image

   # バリデーションの追加
   validates :title, presence: true, length: { minimum: 2, message: "タイトルは5文字以上で入力してください" }
  validates :content, presence: true, length: { minimum: 5, message: "投稿内容は10文字以上で入力してください" }
end
