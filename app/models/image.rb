class Image < ApplicationRecord
  belongs_to :recipe

  mount_uploader :resource, RecipeImageUploader
end
