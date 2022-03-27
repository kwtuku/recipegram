class RecipeImageUploader < BaseUploader
  def public_id
    "#{Rails.env}/recipe/#{Cloudinary::Utils.random_public_id}"
  end

  def default_url(*_args)
    '/images/default_recipe_image.jpg'
  end

  version :thumb do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 640, height: 640
  end
  version :main do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 1200, height: 1200
  end
  version :preview do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 256, height: 256
  end
end
