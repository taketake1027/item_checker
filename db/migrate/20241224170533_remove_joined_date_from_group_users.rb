class RemoveJoinedDateFromGroupUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :group_users, :joined_date
  end
end
