class Relationship < ApplicationRecord
  belongs_to :follow, class_name: 'User'
  belongs_to :user

  counter_culture :follow, column_name: 'followers_count'
  counter_culture :user, column_name: 'followings_count'

  has_one :notification, as: :notifiable, dependent: :destroy

  validates :follow_id, presence: true
  validates :user_id, presence: true
  validates :follow_id, uniqueness: { scope: :user_id }
end
