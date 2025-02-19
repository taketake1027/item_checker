class Item < ApplicationRecord
  has_one_attached :image
  belongs_to :event, optional: true # 自動的な presence チェックを無効化
  has_many :item_requests, dependent: :destroy

  validates :name, :introduction, :status, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_amounts
  validate :validate_event_presence # カスタムバリデーションでエラーを最後に追加

  private

  def validate_amounts
    return if amount.blank? || prepared_amount.blank?

    case status
    when '完了'
      errors.add(:prepared_amount, 'は必要数量と一致する必要があります') if amount != prepared_amount
    when '未完了'
      errors.add(:prepared_amount, 'は必要数量未満である必要があります') if prepared_amount >= amount
    end
  end

  def validate_event_presence
    errors.add(:event, 'を入力してください') if event.nil?
  end
end
