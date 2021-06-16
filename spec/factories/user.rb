FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}"}
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    profile { 'This is my profile.' }
    user_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/user_image_sample.jpg')) }
    trait :with_recipes do
      after(:create) { |user| create_list(:recipe, 5, user: user)}
    end
  end
end
