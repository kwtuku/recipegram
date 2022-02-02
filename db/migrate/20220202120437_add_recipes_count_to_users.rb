class AddRecipesCountToUsers < ActiveRecord::Migration[6.1]
  def self.up
    add_column :users, :recipes_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :recipes_count
  end
end
