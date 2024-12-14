class AddFieldsToGroupUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :group_users do |t|
      t.integer :group_id, null: false, index: true  # グループID
      t.integer :user_id, null: false, index: true  # ユーザーID
      t.date :joined_date, null: false # 参加日
      t.string :position, null: false
      t.string :status, null: false  # ステータス

      t.timestamps  # created_at, updated_at を自動で作成
    end
  end
end
