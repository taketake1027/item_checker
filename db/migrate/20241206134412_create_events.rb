class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :name, null: false                     # イベント名
      t.text :introduction, null: false              # イベント説明
      t.datetime :start_date, null: false            # 開始日
      t.datetime :end_date, null: false              # 終了日
      t.string :location, null: false                # 場所
      t.integer :user_id, null: false                # 作成者ID
      t.string :status, null: false, default: "公開" # ステータス（デフォルト: "公開"）

      t.timestamps                                    # 作成日時と更新日時
    end

    # インデックスの追加
    add_index :events, :name
    add_index :events, :user_id
  end
end
