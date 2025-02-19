class Event < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true # これを追加
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :group_users
  has_many :users, through: :group_users
  has_many :event_requests, dependent: :destroy

  validate :end_date_after_start_date

  # バリデーションの順番を意図的に調整
  validates :name, :introduction, :start_date, :end_date, :location, presence: true
  validates :group_id, presence: true # これを最後に

  # イベントに参加しているかを確認
  def user_participating?(user)
    # 承認されたイベントリクエストがあれば参加とみなす
    return true if event_requests.exists?(user_id: user.id, status: 'approved')

    # 通常通り、グループ参加者のチェック
    group.users.include?(user)
  end

  private

  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date <= start_date
      errors.add(:end_date, "終了日時は開始日時より後である必要があります")
    end
  end
end
