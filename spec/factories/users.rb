FactoryBot.define do
  factory :user do
    username { SecureRandom.urlsafe_base64(11) }
    nickname { Faker::Name.name }
    sequence(:email) { |n| "#{n}#{Faker::Internet.email(domain: 'example.com')}" }
    password { Faker::Internet.password(min_length: 6) }
    profile { Faker::Lorem.paragraphs(number: 3).join(' ') }

    trait :has_5_recipes do
      after(:create) { |user| create_list(:recipe, 5, user: user) }
    end

    trait :with_user_image do
      user_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user_image_sample.jpg')) }
    end
  end
end
