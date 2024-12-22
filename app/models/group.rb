class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  # グループに紐づくイベント
  has_many :events
  has_many :items, through: :events
end
