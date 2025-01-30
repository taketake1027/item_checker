class CreateItemRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :item_requests do |t|
      t.references :item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'pending'  # ここでstatusカラムを追加し、デフォルト値を設定

      t.timestamps
    end
  end
end
