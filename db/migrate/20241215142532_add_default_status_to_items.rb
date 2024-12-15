class AddDefaultStatusToItems < ActiveRecord::Migration[6.0]
  def change
    change_column_default :items, :status, '在庫アリ'
  end
end
