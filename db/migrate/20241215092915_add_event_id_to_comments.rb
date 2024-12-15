class AddEventIdToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :event, null: false, foreign_key: true
  end
end
