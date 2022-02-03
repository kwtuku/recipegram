class AddCommentsCountAndFavoritesCountToRecipes < ActiveRecord::Migration[6.1]
  def self.up
    add_column :recipes, :comments_count, :integer, null: false, default: 0
    add_column :recipes, :favorites_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :recipes, :comments_count
    remove_column :recipes, :favorites_count
  end
end
