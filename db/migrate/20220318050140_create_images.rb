class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :position
      t.string :resource

      t.timestamps
    end
  end
end
