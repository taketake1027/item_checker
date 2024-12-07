class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name, null: false          # グループ名
      t.text :introduction                 # 説明
      t.integer :creator_id, null: false   # 作成者ID
      t.boolean :is_active, null: false, default: true # アクティブ状態

      t.timestamps                         # 作成日時と更新日時
    end

    # インデックスの追加
    add_index :groups, :name
    add_index :groups, :creator_id
  end
end
