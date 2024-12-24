class AddJoinedDateToGroupUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :group_users, :joined_date, :date, null: false
  end
end
