class AddDeviseToAdmins < ActiveRecord::Migration[6.1]
  def self.up
    create_table :admins do |t| # 管理者テーブルを作成
      t.integer :user_id, null: false # ユーザーID
      t.string :role, null: false # 権限

      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
    end

    add_index :admins, :email, unique: true
    add_index :admins, :reset_password_token, unique: true
    add_index :admins, :user_id # ユーザーIDにインデックス
  end

  def self.down
    drop_table :admins
  end
end
