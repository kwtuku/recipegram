class AddFollowersCountAndFollowingsCountToUsers < ActiveRecord::Migration[6.1]
  def self.up
    add_column :users, :followers_count, :integer, null: false, default: 0
    add_column :users, :followings_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :followers_count
    remove_column :users, :followings_count
  end
end
