FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    body { Faker::Lorem.paragraphs(number: 3).join(' ') }
    association :user

    trait :with_images do
      transient { images_count { 2 } }

      after(:create) do |recipe, evaluator|
        create_list(:existing_image, evaluator.images_count, recipe: recipe)
        recipe.reload.images.shuffle.each.with_index(1) { |image, i| image.update(position: i) }
        recipe.reload
      end
    end
  end
end
