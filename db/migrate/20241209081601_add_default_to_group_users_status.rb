class AddDefaultToGroupUsersStatus < ActiveRecord::Migration[6.0]
  def change
    change_column_default :group_users, :status, 'active'
  end
end
