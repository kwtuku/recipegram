Faker::Config.locale = :en

def create_characteristic_user_recipe_comment
  common_password = 'fffffr'

  user = User.create!(
    username:              "l#{'o'*9}ng",
    nickname:              "very_l#{'o'*17}ng_word",
    email:                 'long@example.com',
    password:              common_password,
    password_confirmation: common_password,
    profile:               "very_l#{'o'*487}ng_word",
    user_image:            File.open("./db/fixtures/user/user_sample_#{rand(1..15)}.jpg"),
  )
  puts 'ユーザーを作成完了'

  recipe = user.recipes.create!(
    title:        "very_l#{'o'*17}ng_word",
    body:         "very_l#{'o'*1987}ng_word",
    recipe_image: File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..15)}.jpg"),
  )
  puts 'レシピを作成完了'

  user.comments.create!(
    recipe_id: recipe.id,
    body:      "very_l#{'o'*487}ng_word",
  )
  puts 'コメントを作成完了'
end

def create_user(user_creation_time)
  puts "ユーザーを#{user_creation_time}回作成"

  common_password = 'fffffr'

  user_example_emails = User.all.pluck(:email).grep(/example(.+)@example.com/)
  last_email_number = user_example_emails.blank? ? 0 : user_example_emails.map{ |email| email.gsub(/example(.+)@example.com/, '\+').to_i }.max

  user_creation_time.times do |n|
    nickname  = Faker::Lorem.words(number: rand(1..10)).join(' ')
    email = "example#{last_email_number + n + 1}@example.com"
    profile = Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')
    user_image = File.open("./db/fixtures/user/user_sample_#{rand(1..15)}.jpg")

    User.create!(
      username:              User.generate_username,
      nickname:              nickname[0..29],
      email:                 email,
      password:              common_password,
      password_confirmation: common_password,
      profile:               profile[0..499],
      user_image:            user_image,
    )

    user_creation_time -= 1
    puts user_creation_time == 0 ? 'ユーザー作成完了' : "あと#{user_creation_time}回"
  end
end

def create_relationship(create_relationship_time)
  puts "フォローを#{create_relationship_time}回作成"

  users = User.all

  users.sample(create_relationship_time).each do |user|
    followed_ids = User.ids.sample(rand(1..users.size)) - [user.id]
    followed_ids.each do |followed_id|
      user.relationships.find_or_create_by(follow_id: followed_id)
    end
    puts "#{user.id}が#{followed_ids}をフォロー"
  end
end

def create_recipe(recipe_creation_time)
  puts "レシピを#{recipe_creation_time}回作成"

  recipe_creation_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')
    recipe_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
    TEXT
    recipe_image = File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..15)}.jpg")

    User.all.sample.recipes.create!(
      title: recipe_title[0..29],
      body: recipe_body[0..1999],
      recipe_image: recipe_image,
    )

    recipe_creation_time -= 1
    puts recipe_creation_time == 0 ? 'レシピ作成完了' : "あと#{recipe_creation_time}回"
  end
end

def create_comment(comment_creation_time)
  puts "コメントを#{comment_creation_time}回作成"

  comment_creation_time.times do
    comment_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
    TEXT

    User.all.sample.comments.create!(
      recipe_id: Recipe.all.sample.id,
      body: comment_body[0..499],
    )
    comment_creation_time -= 1
    puts comment_creation_time == 0 ? 'コメント作成完了' : "あと#{comment_creation_time}回"
  end
end

def create_favorite(favorite_creation_time)
  puts "いいねを#{favorite_creation_time}回作成"

  favorite_creation_time.times do
    User.all.sample.favorites.find_or_create_by(recipe_id: Recipe.all.sample.id)

    favorite_creation_time -= 1
    puts favorite_creation_time == 0 ? 'いいね作成完了' : "あと#{favorite_creation_time}回"
  end
end

def update_recipe(recipe_updating_time)
  puts "レシピを#{recipe_updating_time}回更新"

  recipe_updating_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')
    recipe_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
    TEXT

    target_recipe = Recipe.all.sample
    target_recipe.update!(
      title: recipe_title[0..29],
      body: recipe_body[0..1999],
    )

    recipe_updating_time -= 1
    puts "#{target_recipe.id}を更新"
    puts recipe_updating_time == 0 ? 'レシピ更新完了' : "あと#{recipe_updating_time}回"
  end
end

def create_notification_of_one_user(notification_creation_time, user_id)
  puts "#{user_id}の通知を#{notification_creation_time}回作成"

  user = User.find(user_id)
  other_user_ids = User.ids - [user.id]

  unless user.recipes.present?
    puts 'ユーザーのレシピがありません'
    return
  end

  notification_creation_time.times do
    other_user = User.find(other_user_ids.sample)

    comment_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
    TEXT

    other_user_comment = other_user.comments.create(
      recipe_id: user.recipes.sample.id,
      body: comment_body,
    )
    Notification.create_comment_notification(other_user_comment)

    other_user_favorite = other_user.favorites.find_or_create_by(
      recipe_id: user.recipes.sample.id,
    )
    Notification.create_favorite_notification(other_user_favorite)

    other_user_relationship = other_user.relationships.find_or_create_by(
      follow_id: user.id,
    )
    Notification.create_relationship_notification(other_user_relationship)

    notification_creation_time -= 1
    puts notification_creation_time == 0 ? '通知作成完了' : "あと#{notification_creation_time}回"
  end
end

def create_recipe_of_one_user(recipe_creation_time, user_id)
  puts "#{user_id}のレシピを#{recipe_creation_time}回作成"

  recipe_creation_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')
    recipe_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
    TEXT
    recipe_image = File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..15)}.jpg")

    User.find(user_id).recipes.create!(
      title: recipe_title[0..29],
      body: recipe_body[0..1999],
      recipe_image: recipe_image,
    )

    recipe_creation_time -= 1
    puts recipe_creation_time == 0 ? "#{user_id}のレシピ作成完了" : "あと#{recipe_creation_time}回"
  end
end

def create_comment_of_one_user(comment_creation_time, user_id)
  puts "#{user_id}のコメントを#{comment_creation_time}回作成"

  comment_creation_time.times do
    comment_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
    TEXT

    User.find(user_id).comments.create!(
      body: comment_body[0..499],
      recipe_id: Recipe.all.sample.id,
    )

    comment_creation_time -= 1
    puts comment_creation_time == 0 ? "#{user_id}のコメント作成完了" : "あと#{comment_creation_time}回"
  end
end

def create_favorite_of_one_user(favorite_creation_time, user_id)
  puts "#{user_id}のいいねを#{favorite_creation_time}回作成"

  favorite_creation_time.times do
    User.find(user_id).favorites.find_or_create_by(recipe_id: Recipe.all.sample.id)

    favorite_creation_time -= 1
    puts favorite_creation_time == 0 ? "#{user_id}のいいね作成完了" : "あと#{favorite_creation_time}回"
  end
end

create_characteristic_user_recipe_comment
create_user(time)
create_relationship(time)
create_recipe(time)
create_comment(time)
create_favorite(time)
update_recipe(time)
create_notification_of_one_user(time, user_id)
create_recipe_of_one_user(time, user_id)
create_comment_of_one_user(time, user_id)
create_favorite_of_one_user(time, user_id)
