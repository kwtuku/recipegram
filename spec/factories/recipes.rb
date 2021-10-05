FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    body { Faker::Lorem.paragraphs(number: 3).join(' ') }
    recipe_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/recipe_image_sample.jpg')) }
    association :user

    trait :no_image do
      recipe_image { '' }
      association :user, :no_image
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
