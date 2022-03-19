class Image < ApplicationRecord
  belongs_to :recipe

  before_destroy :validate_min_images_count

  mount_uploader :resource, RecipeImageUploader

  validates :resource, presence: true
  validate :validate_max_images_count, if: -> { validation_context != :recipe_form_save }

  MAX_IMAGES_COUNT = 10
  MIN_IMAGES_COUNT = 1

  private

  def validate_max_images_count
    return if recipe.images.size <= MAX_IMAGES_COUNT

    errors.add(:base, :too_many_images, message: "画像は#{MAX_IMAGES_COUNT}枚以下にしてください")
  end

  def validate_min_images_count
    return if recipe.images.size > MIN_IMAGES_COUNT

    errors.add(:base, :require_images, message: "画像が#{MIN_IMAGES_COUNT}枚以上必要です")
    throw :abort
  end
end
