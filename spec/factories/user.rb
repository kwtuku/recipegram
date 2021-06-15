FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}"}
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :with_recipes do
      after(:create) { |user| create_list(:recipe, 5, user: user)}
    end
  end
end
