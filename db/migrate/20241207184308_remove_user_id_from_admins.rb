class RemoveUserIdFromAdmins < ActiveRecord::Migration[6.1]
  def change
    # インデックスを削除
    remove_index :admins, :user_id

    # カラムを削除
    remove_column :admins, :user_id, :integer
  end
end
