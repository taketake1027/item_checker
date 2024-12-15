class CreateItemEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :item_events do |t|
      t.integer :item_id, null: false # アイテムID（外部キー）
      t.integer :event_id, null: false # イベントID（外部キー）
      t.integer :amount, null: false # 数量

      t.timestamps # 作成日時と更新日時（自動で追加される）
    end

    # 外部キー制約を追加（アイテムIDとイベントID）
    add_foreign_key :item_events, :items, column: :item_id
    add_foreign_key :item_events, :events, column: :event_id

    # アイテムIDとイベントIDにインデックスを追加
    add_index :item_events, :item_id
    add_index :item_events, :event_id
  end
end
