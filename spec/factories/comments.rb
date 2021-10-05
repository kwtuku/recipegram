FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraphs(number: 3).join(' ') }
    association :user
    association :recipe
  end
end
