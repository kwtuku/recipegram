Faker::Config.locale = :en

def create_characteristic_user_recipe_comment
  common_password = 'fffffr'

  User.create!(
    username:              "l#{'o'*12}ng",
    nickname:              "very_l#{'o'*100}ng_word",
    email:                 'long@example.com',
    password:              common_password,
    password_confirmation: common_password,
    profile:               "very_l#{'o'*500}ng_word",
    user_image:            File.open("./db/fixtures/user/user_sample_#{rand(1..15)}.jpg"),
  )

  user = User.find_by(email: 'long@example.com')
  user.recipes.create!(
    title:        "very_l#{'o'*100}ng_word",
    body:         "very_l#{'o'*900}ng_word",
    recipe_image: File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..15)}.jpg")
  )

  recipe = Recipe.last
  user.comments.create!(
    recipe_id: recipe.id,
    body:      "very_l#{'o'*500}ng_word",
  )
end

def create_user(user_creation_time)
  creation_time = 0
  common_password = 'fffffr'

  user_example_emails = User.all.pluck(:email).grep(/example(.+)@example.com/)
  last_email_number = user_example_emails.blank? ? 0 : user_example_emails.map{ |email| email.gsub(/example(.+)@example.com/, '\+').to_i }.max

  user_creation_time.times do |n|
    nickname  = Faker::Lorem.words(number: rand(1..10)).join(' ')
    email = "example#{last_email_number + n + 1}@example.com"
    profile = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(3..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(3..8)).join(' ')}
    TEXT
    user_image = File.open("./db/fixtures/user/user_sample_#{rand(1..15)}.jpg")

    User.create!(
      username:              User.generate_username,
      nickname:              nickname,
      email:                 email,
      password:              common_password,
      password_confirmation: common_password,
      profile:               profile,
      user_image:            user_image,
    )

    creation_time += 1
    puts creation_time
  end
end

def create_relationship(create_relationship_time)
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
  creation_time = 0
  recipe_creation_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')
    recipe_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(3..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(3..8)).join(' ')}
    TEXT
    recipe_image = File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..15)}.jpg")

    User.all.sample.recipes.create!(title: recipe_title, body: recipe_body, recipe_image: recipe_image)
    creation_time += 1
    puts creation_time
  end
end

def create_comment(comment_creation_time)
  creation_time = 0
  comment_creation_time.times do
    comment_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..8)).join(' ')}
    TEXT

    User.all.sample.comments.create!(body: comment_body, recipe_id: Recipe.all.sample.id)
    creation_time += 1
    puts creation_time
  end
end

def create_favorite(favorite_creation_time)
  creation_time = 0
  favorite_creation_time.times do
    User.all.sample.favorites.find_or_create_by(recipe_id: Recipe.all.sample.id)
    creation_time += 1
    puts creation_time
  end
end

def update_recipe(recipe_updating_time)
  recipe_updating_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')
    recipe_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(3..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(3..8)).join(' ')}
    TEXT

    Recipe.all.sample.update!(title: recipe_title, body: recipe_body)
  end
end

def create_notification_for_one_user(notification_creation_time, user_id)
  creation_time = 0

  user = User.find(user_id)
  other_user_ids = User.ids - [user.id]

  unless user.recipes.present?
    puts 'ユーザーのレシピがありません'
    return
  end

  notification_creation_time.times do
    other_user = User.find(other_user_ids.sample)
    user_recipe = user.recipes.sample
    other_user_recipes = Recipe.all - user.recipes
    other_user_comments = Comment.all - user.comments
    other_user_comment = other_user_comments.sample

    other_user_comment.create_comment_notification!(other_user, other_user_comment.id, user_recipe.id)
    other_user_comment.create_comment_notification!(other_user, other_user_comment.id, other_user_recipes.sample.id)
    user_recipe.create_favorite_notification!(other_user)
    user.create_follow_notification!(other_user)

    creation_time += 1
    puts creation_time
  end
end

def create_recipe_for_one_user(recipe_creation_time, user_id)
  creation_time = 0
  recipe_creation_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')
    recipe_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(3..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(3..8)).join(' ')}
    TEXT
    recipe_image = File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..15)}.jpg")

    User.find(user_id).recipes.create!(title: recipe_title, body: recipe_body, recipe_image: recipe_image)
    creation_time += 1
    puts creation_time
  end
end

def create_comment_for_one_user(comment_creation_time, user_id)
  creation_time = 0
  comment_creation_time.times do
    comment_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(5..8)).join(' ')}
    TEXT

    User.find(user_id).comments.create!(body: comment_body, recipe_id: Recipe.all.sample.id)
    creation_time += 1
    puts creation_time
  end
end

def create_favorite_for_one_user(favorite_creation_time, user_id)
  creation_time = 0
  favorite_creation_time.times do
    User.find(user_id).favorites.find_or_create_by(recipe_id: Recipe.all.sample.id)
    creation_time += 1
    puts creation_time
  end
end

create_characteristic_user_recipe_comment
create_user(time)
create_relationship(time)
create_recipe(time)
create_comment(time)
create_favorite(time)
update_recipe(time)
create_notification_for_one_user(time, user_id)
create_recipe_for_one_user(time, user_id)
create_comment_for_one_user(time, user_id)
create_favorite_for_one_user(time, user_id)
