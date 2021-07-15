class Relationship < ApplicationRecord
  belongs_to :follow, class_name: 'User'
  belongs_to :user

  has_one :notification, as: :notifiable, dependent: :destroy

  validates :follow_id, presence: true
  validates :user_id, presence: true
end
