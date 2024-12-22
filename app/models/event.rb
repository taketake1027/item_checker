# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :users, through: :group_participations

  def add_users(user_ids)
    self.users = User.where(id: user_ids)
  end
  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date <= start_date
      errors.add(:end_date, "終了日時は開始日時より後である必要があります")
    end
  end
end
