class UserImageUploader < BaseUploader
  def public_id
    "#{Rails.env}/user/#{Cloudinary::Utils.random_public_id}"
  end

  def default_url(*_args)
    '/images/default_user_image.jpg'
  end

  version :icon do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 150, height: 150
  end
  version :thumb do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 320, height: 320
  end
  version :preview do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 400, height: 400
  end
end
