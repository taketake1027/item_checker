class AddContentToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :content, :text
  end
end
