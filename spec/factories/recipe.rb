FactoryBot.define do
  factory :recipe do
    title { 'カレー' }
    body { '切ったにんじん、玉ねぎ、じゃがいも、肉とルーを鍋で煮込む。' }
    recipe_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/recipe_image_sample.jpg')) }
    association :user

    trait :no_image do
      recipe_image { '' }
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
