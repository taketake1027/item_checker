class AddLeaderAndItemEditorToEvents < ActiveRecord::Migration[6.1]
  def change
    # リーダーIDを追加
    add_column :events, :leader_id, :integer
    
    # アイテム編集者のID配列を追加
    add_column :events, :item_editor_ids, :integer, array: true, default: []
    
    # `default`カラムが必要なら、適切な名前に変更
    # add_column :events, :default, :string  # 名前を適切に変更することを検討してください
  end
end
