class TagFollowing < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :tag

  validates :follower_id, uniqueness: { scope: :tag_id }
end
