FactoryBot.define do
  factory :user do
    username { SecureRandom.urlsafe_base64(11) }
    nickname { Faker::Name.name }
    sequence(:email) { |n| "#{n}#{Faker::Internet.email(domain: 'example.com')}" }
    faker_password = Faker::Internet.password(min_length: 6)
    password { faker_password }
    password_confirmation { faker_password }
    profile { Faker::Lorem.paragraphs(number: 3).join(' ') }
    user_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user_image_sample.jpg')) }

    trait :has_5_recipes do
      after(:create) { |user| create_list(:recipe, 5, :no_image, user: user) }
    end

    trait :no_image do
      user_image { '' }
    end
  end
end
