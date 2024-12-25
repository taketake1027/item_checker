class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :events
  has_many :items, through: :events
  
  validates :name, presence: true
  validates :introduction, presence: true
end
