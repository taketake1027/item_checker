class Item < ApplicationRecord
  has_one_attached :image
  belongs_to :group, optional: true # グループが選択されていなくてもエラーにならない
  belongs_to :event, optional: true  # イベントとの関連付け
  validates :name, presence: true
  validates :introduction, presence: true
  validates :status, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
