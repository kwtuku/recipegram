class AddImagesCountToRecipes < ActiveRecord::Migration[6.1]
  def self.up
    add_column :recipes, :images_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :recipes, :images_count
  end
end
