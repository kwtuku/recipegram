class Favorite < ApplicationRecord
  belongs_to :recipe
  belongs_to :user

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates_uniqueness_of :recipe_id, scope: :user_id
end
