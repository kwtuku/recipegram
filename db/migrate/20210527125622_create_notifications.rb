class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.bigint :notifiable_id, null: false
      t.bigint :receiver_id, null: false
      t.string  :notifiable_type, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
