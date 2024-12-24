class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  # positionカラムにデフォルト値を設定
  after_initialize :set_default_position, if: :new_record?
  validates :joined_date, presence: true
  private

  def set_default_position
    self.position ||= 0  # positionがnilなら0を設定
  end
  
  def set_default_joined_date
    self.joined_date ||= Date.today  # デフォルトで今日の日付
  end
end
