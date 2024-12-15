# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :posts, dependent: :destroy
  # has_many :items, dependent: :destroy  # イベントには複数のアイテムが関連付けられます
  # has_many :comments, dependent: :destroy  # イベントには複数のコメントが関連付けられます

  # 他のバリデーションやメソッド
end
