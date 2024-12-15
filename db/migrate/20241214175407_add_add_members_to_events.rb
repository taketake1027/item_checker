class AddAddMembersToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :add_members, :string
  end
end
