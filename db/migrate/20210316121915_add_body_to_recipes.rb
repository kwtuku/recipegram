class AddBodyToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :body, :text
  end
end
