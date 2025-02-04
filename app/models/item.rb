class Item < ApplicationRecord
  has_one_attached :image
  belongs_to :event
  has_many :item_requests, dependent: :destroy
  
  validates :name, presence: true
  validates :introduction, presence: true
  validates :status, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_amounts
  validates :event, presence: true  # eventが必須
  private

  def validate_amounts
    # amountとprepared_amountがnilでないことを確認
    if amount.nil? || prepared_amount.nil?
      errors.add(:base, '必要数量と準備済み数量の両方を入力してください')
      return
    end

    if status == '完了'
      if amount != prepared_amount
        errors.add(:prepared_amount, 'は必要数量と一致する必要があります')
      end
    elsif status == '未完了'
      if prepared_amount >= amount
        errors.add(:prepared_amount, 'は必要数量より少なくする必要があります')
      end
    end
  end
end