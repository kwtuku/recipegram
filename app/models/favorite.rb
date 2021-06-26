class Favorite < ApplicationRecord
  belongs_to :recipe
  belongs_to :user

  validates_uniqueness_of :recipe_id, scope: :user_id
end
