class RemoveImageIdFromRecipe < ActiveRecord::Migration[6.1]
  def change
    remove_column :recipes, :image_id, :string
  end
end
