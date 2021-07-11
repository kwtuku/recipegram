class RemoveProfileImageIdFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :profile_image_id, :string
  end
end
