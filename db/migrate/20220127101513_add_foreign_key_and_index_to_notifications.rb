class AddForeignKeyAndIndexToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :notifications, :users, column: :receiver_id
    add_index :notifications, :receiver_id
  end
end
