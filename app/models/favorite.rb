class Favorite < ApplicationRecord
  belongs_to :recipe
  belongs_to :user

  counter_culture :recipe

  has_one :notification, as: :notifiable, dependent: :destroy

  validates :recipe_id, uniqueness: { scope: :user_id }
end
