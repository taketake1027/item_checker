class RemoveLocationFromItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :items, :location, :string
  end
end
