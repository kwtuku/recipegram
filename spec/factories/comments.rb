FactoryBot.define do
  factory :comment do
    body { 'すばらしい！' }
    association :user
    association :recipe
  end
end
