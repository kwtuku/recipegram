namespace :create_image_from_recipe_image do
  desc 'Create Image from recipe_image '
  task run: :environment do
    recipes_with_no_images = Recipe.where.missing(:images)
    count = recipes_with_no_images.size
    Rails.logger = Logger.new($stdout)
    recipes_with_no_images.find_each do |recipe|
      Rails.logger.debug "Recipe id: #{recipe.id}"
      recipe.images.create!(
        resource: Cloudinary::CarrierWave::StoredFile.new(recipe.recipe_image.identifier),
        position: 1
      )
      count -= 1
      Rails.logger.debug "あと#{count}回" unless count.zero?
    end
  end
end
