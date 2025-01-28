class CreateEventRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :event_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
