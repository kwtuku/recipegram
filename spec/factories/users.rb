FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "username#{n}" }
    sequence(:nickname) { |n| "nickname#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    profile { 'This is my profile.' }
    user_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user_image_sample.jpg')) }

    trait :has_5_recipes do
      after(:create) { |user| create_list(:recipe, 5, :no_image, user: user) }
    end

    trait :no_image do
      user_image { '' }
    end
  end
end
