Faker::Config.locale = :en

def create_user(user_creation_time)
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
    profile:               Faker::Lorem.paragraph(sentence_count: rand(1..20)),
    user_image:            File.open("./public/images/seeds/#{sample_user_imgs.sample}"),
  )

  user_creation_time.times do |n|
    username  = Faker::Lorem.words(number: rand(1..10)).join(" ")
    email = "example#{n+1}@example.com"
    profile = Faker::Lorem.paragraph(sentence_count: rand(1..20))
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
end

def create_relationship
  users = User.all

  users.each do |user|
    rand(users.size).times do
      followed = users.sample
      unless user.id == followed.id
        user.relationships.find_or_create_by(follow_id: followed.id)
      end
    end
  end
end

def create_recipe(recipe_creation_time)
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

  recipe_creation_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(" ")
    recipe_body = Faker::Lorem.paragraphs(number: rand(5..40)).join("\n")
    recipe_image = File.open("./public/images/seeds/#{sample_recipe_imgs.sample}")
    User.all.sample.recipes.create!(title: recipe_title, body: recipe_body, recipe_image: recipe_image)
  end
end

def create_comment(comment_creation_time)
  comment_creation_time.times do
    comment_body = Faker::Lorem.paragraphs(number: rand(1..10)).join("\n")
    User.all.sample.comments.create!(body: comment_body, recipe_id: Recipe.all.sample.id)
  end
end

def create_favorite(favorite_creation_time)
  favorite_creation_time.times do
    User.all.sample.favorites.find_or_create_by(recipe_id: Recipe.all.sample.id)
  end
end

create_user(100)
create_relationship
create_recipe(100)
create_comment(500)
create_favorite(500)
