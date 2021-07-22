FactoryBot.define do
  factory :user do
    sequence(:nickname) { |n| "user#{n}"}
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    profile { 'This is my profile.' }
    user_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/user_image_sample.jpg')) }

    trait :has_5_recipes do
      after(:create) { |user| create_list(:recipe, 5, :no_image, user: user)}
    end

    trait :no_image do
      user_image { '' }
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
