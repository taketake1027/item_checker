class AddEventIdToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :event_id, :integer
  end
end
