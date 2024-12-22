class AddPreparedAmountToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :prepared_amount, :integer
  end
end
