FactoryBot.define do
  factory :image do
    resource { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/recipe_image_sample.jpg')) }
    association :recipe

    factory :existing_image do
      resource { '' }
      to_create do |image|
        image.valid?
        if image.errors.messages == { resource: ['を入力してください'] }
          image.save(validate: false)
          image.update_column(:resource, "image/upload/v#{Time.now.to_i}/#{SecureRandom.hex(10)}.jpg") # rubocop:disable Rails/SkipsModelValidations
        else
          image.save!
        end
      end
    end
  end
end
