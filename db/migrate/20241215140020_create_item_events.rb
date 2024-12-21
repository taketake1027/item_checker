class CreateItemEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :item_events do |t|
      t.references :item, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.integer :amount, null: false # 数量

      t.timestamps # 作成日時と更新日時（自動で追加される）
    end
  end
end
