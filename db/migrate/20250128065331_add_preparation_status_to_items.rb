class AddPreparationStatusToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :preparation_status, :string
  end
end
