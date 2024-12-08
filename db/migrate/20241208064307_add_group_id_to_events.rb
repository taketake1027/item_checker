class AddGroupIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :group_id, :integer
    add_index :events, :group_id  # インデックスを追加（必要に応じて）
  end
end
