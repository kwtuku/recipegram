FactoryBot.define do
  factory :image do
    resource { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/recipe_image_sample.jpg')) }
    association :recipe
  end
end
