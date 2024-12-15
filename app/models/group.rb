class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :items
  # グループに紐づくイベント
  has_many :events
end
