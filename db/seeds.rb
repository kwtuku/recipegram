Faker::Config.locale = :en

password = "ffffff"
sample_user_imgs = %w(
  ウキウキな仔犬.jpg
  おはようキバタン.jpg
  ご機嫌のオカメインコ.jpg
  ニヒルなキバタン.jpg
  呼ぶネコ.jpg
  初めましてイワシャコです.jpg
  分かんなくなった柴犬.jpg
)

User.create!(
  username:              Faker::Lorem.words(number: rand(1..10)).join(" "),
  email:                 "example@example.com",
  password:              password,
  password_confirmation: password,
  profile:               Faker::Lorem.paragraph(sentence_count: rand(1..10)),
  user_image:            File.open("./public/images/seeds/#{sample_user_imgs.sample}"),
)

user_creation_time = 100
user_creation_time.times do |n|
  username  = Faker::Lorem.words(number: rand(1..10)).join(" ")
  email = "example#{n+1}@example.com"
  profile = Faker::Lorem.paragraph(sentence_count: rand(1..10))
  user_image = File.open("./public/images/seeds/#{sample_user_imgs.sample}")
  User.create!(
    username:              username,
    email:                 email,
    password:              password,
    password_confirmation: password,
    profile:               profile,
    user_image:            user_image,
  )
end

users = User.all

users.each do |user|
  rand(users.size).times do
    followed = users.sample
    unless user.id == followed.id
      user.relationships.find_or_create_by(follow_id: followed.id)
    end
  end
end

sample_recipe_imgs = %w(
  bread-2178874_1280.webp
  japanese_dinner_color.png
  japanese-food-802999_1280.jpg
  pizza-329523_1280.jpg
  sashimi-4235910_1280.jpg
  アサイーボウル.png
  パンケーキ.png
  ポークチャップ.png
  ミールス.png
)

recipe_creation_time = 100
recipe_creation_time.times do
  recipe_title = Faker::Lorem.words(number: rand(1..10)).join(" ")
  recipe_body = Faker::Lorem.paragraphs(number: rand(5..10)).join("\n")
  recipe_image = File.open("./public/images/seeds/#{sample_recipe_imgs.sample}")
  users.sample.recipes.create!(title: recipe_title, body: recipe_body, recipe_image: recipe_image)
end

comment_creation_time = 100
comment_creation_time.times do
  comment_body = Faker::Lorem.paragraphs(number: rand(1..10)).join("\n")
  users.sample.comments.create!(body: comment_body, recipe_id: Recipe.all.sample.id)
end

favorite_creation_time = 100
favorite_creation_time.times do
  users.sample.favorites.find_or_create_by(recipe_id: Recipe.all.sample.id)
end
