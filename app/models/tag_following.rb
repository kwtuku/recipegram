class TagFollowing < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :tag
end
