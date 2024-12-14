class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  # positionカラムにデフォルト値を設定
  after_initialize :set_default_position, if: :new_record?

  private

  def set_default_position
    self.position ||= 0  # positionがnilなら0を設定
  end
end
