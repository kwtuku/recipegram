class UserImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave

  def public_id
    "#{Rails.env}/user/#{Cloudinary::Utils.random_public_id}"
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*_args)
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    '/images/default_user_image.jpg'
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :icon do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 150, height: 150
  end
  version :thumb do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 320, height: 320
  end
  version :preview do
    cloudinary_transformation crop: :fill, quality: :auto, fetch_format: :auto, width: 400, height: 400
  end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w[jpeg jpg png webp]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def size_range
    1..2.megabytes
  end
end
