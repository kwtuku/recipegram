class CreateTagFollowings < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_followings do |t|
      t.references :follower, foreign_key: { to_table: :users }, null: false
      t.references :tag, foreign_key: true, null: false

      t.timestamps

      t.index [:follower_id, :tag_id], unique: true
    end
  end
end
