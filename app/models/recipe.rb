class Recipe < ApplicationRecord
  attachment :image
  belongs_to :user
end
