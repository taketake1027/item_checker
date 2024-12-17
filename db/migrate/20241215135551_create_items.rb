class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false # アイテム名
      t.string :introduction, null: false # アイテム説明
      t.string :status, null: false, default: 'active' # ステータス（デフォルト値を 'active'）
      t.integer :amount, null: false # 数量

      # timestampsは自動的に生成されるため、明示的に書く必要はありません
    end
  end
end
