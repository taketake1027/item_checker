class Event < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :group_users
  has_many :users, through: :group_users
  has_many :event_requests, dependent: :destroy

  validate :end_date_after_start_date
  validates :name, presence: true
  validates :introduction, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :group_id, presence: true

   # イベントに参加しているかを確認
  def user_participating?(user)
    # イベントに参加しているか確認するためには、group_usersテーブルを通じて、グループに参加しているユーザーかどうかをチェック
    self.group.users.include?(user)
  end

  private

  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date <= start_date
      errors.add(:end_date, "終了日時は開始日時より後である必要があります")
    end
  end
end
