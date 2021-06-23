class Relationship < ApplicationRecord
  belongs_to :follow, class_name: 'User'
  belongs_to :user

  validates :follow_id, presence: true
  validates :user_id, presence: true
end
