Rails.logger = Logger.new($stdout)
Faker::Config.locale = :en

def generate_paragraphs(max_chars_count)
  chars_count = rand(10..max_chars_count)
  new_lines_count = rand(1..(chars_count / 50)) || 0
  not_new_line_chars_count = chars_count - new_lines_count * 2

  rands = Array.new(new_lines_count) { rand(1..(not_new_line_chars_count - 1)) }
  rands.push(0, not_new_line_chars_count)
  rands.sort!
  paragraph_chars_counts = rands.drop(1).zip(rands).map { |a, b| a - b }.delete_if(&:zero?)
  paragraphs = paragraph_chars_counts.map do |paragraph_chars_count|
    Faker::Lorem.paragraph_by_chars(number: paragraph_chars_count, supplemental: false)
  end

  paragraphs.join("\r\n")
end

def create_long_word_user_recipe_comment
  password_for_production = Rails.application.credentials.seed[:user_password]
  common_password = Rails.env.production? ? password_for_production : 'fffffr'

  user = User.create!(
    username: "l#{'o' * 9}ng",
    nickname: "very_long_w#{'o' * 17}rd",
    email: 'long@example.com',
    password: common_password,
    password_confirmation: common_password,
    profile: "very_long_w#{'o' * 487}rd",
    user_image: File.open("./db/fixtures/user/user_sample_#{rand(1..30)}.jpg")
  )
  Rails.logger.debug 'ユーザーを作成完了'

  recipe = user.recipes.create!(
    title: "very_long_w#{'o' * 17}rd",
    body: "very_long_w#{'o' * 1987}rd",
    recipe_image: File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..30)}.jpg"),
    tag_list: "very_long_w#{'o' * 7}rd"
  )
  Rails.logger.debug 'レシピを作成完了'

  user.comments.create!(
    recipe_id: recipe.id,
    body: "very_long_w#{'o' * 487}rd"
  )
  Rails.logger.debug 'コメントを作成完了'
end

def create_user(user_creation_time)
  Rails.logger.debug "ユーザーを#{user_creation_time}回作成"

  password_for_production = Rails.application.credentials.seed[:user_password]
  common_password = Rails.env.production? ? password_for_production : 'fffffr'

  user_example_emails = User.all.pluck(:email).grep(/example(.+)@example.com/)
  last_email_number =
    if user_example_emails.blank?
      0
    else
      user_example_emails.map { |email| email.gsub(/example(.+)@example.com/, '\+').to_i }.max
    end

  user_creation_time.times do |n|
    nickname = Faker::Lorem.words(number: rand(1..10)).join(' ')[0..29]
    email = "example#{last_email_number + n + 1}@example.com"
    profile = Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')[0..499]
    user_image = File.open("./db/fixtures/user/user_sample_#{rand(1..30)}.jpg")

    User.create!(
      username: User.generate_username,
      nickname: nickname,
      email: email,
      password: common_password,
      password_confirmation: common_password,
      profile: profile,
      user_image: user_image
    )

    user_creation_time -= 1
    Rails.logger.debug user_creation_time.zero? ? 'ユーザー作成完了' : "あと#{user_creation_time}回"
  end
end

def create_relationship(create_relationship_time)
  Rails.logger.debug "フォローを#{create_relationship_time}回作成"

  users = User.all

  users.sample(create_relationship_time).each do |user|
    followed_ids = User.ids.sample(rand(1..users.size)) - [user.id]
    followed_ids.each do |followed_id|
      user.relationships.find_or_create_by(follow_id: followed_id)
    end
    Rails.logger.debug "#{user.id}が#{followed_ids}をフォロー"
  end
end

def create_recipe(recipe_creation_time)
  Rails.logger.debug "レシピを#{recipe_creation_time}回作成"

  recipe_creation_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')[0..29]
    recipe_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
    TEXT
    recipe_image = File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..30)}.jpg")

    User.all.sample.recipes.create!(
      title: recipe_title,
      body: recipe_body[0..1999],
      recipe_image: recipe_image,
      tag_list: Faker::Lorem.words(number: rand(1..5)).join(', ')
    )

    recipe_creation_time -= 1
    Rails.logger.debug recipe_creation_time.zero? ? 'レシピ作成完了' : "あと#{recipe_creation_time}回"
  end
end

def create_comment(comment_creation_time)
  Rails.logger.debug "コメントを#{comment_creation_time}回作成"

  comment_creation_time.times do
    comment_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
    TEXT

    User.all.sample.comments.create!(
      recipe_id: Recipe.ids.sample,
      body: comment_body[0..499]
    )
    comment_creation_time -= 1
    Rails.logger.debug comment_creation_time.zero? ? 'コメント作成完了' : "あと#{comment_creation_time}回"
  end
end

def create_favorite(favorite_creation_time)
  Rails.logger.debug "いいねを#{favorite_creation_time}回作成"

  favorite_creation_time.times do
    User.all.sample.favorites.find_or_create_by(recipe_id: Recipe.ids.sample)

    favorite_creation_time -= 1
    Rails.logger.debug favorite_creation_time.zero? ? 'いいね作成完了' : "あと#{favorite_creation_time}回"
  end
end

def update_recipe(recipe_updating_time)
  Rails.logger.debug "レシピを#{recipe_updating_time}回更新"

  recipe_updating_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')[0..29]
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
      title: recipe_title,
      body: recipe_body[0..1999],
      tag_list: Faker::Lorem.words(number: rand(1..5)).join(', ')
    )

    recipe_updating_time -= 1
    Rails.logger.debug "#{target_recipe.id}を更新"
    Rails.logger.debug recipe_updating_time.zero? ? 'レシピ更新完了' : "あと#{recipe_updating_time}回"
  end
end

def create_notification_of_one_user(notification_creation_time, user_id)
  Rails.logger.debug "#{user_id}の通知を#{notification_creation_time}回作成"

  user = User.find(user_id)
  other_user_ids = User.ids - [user.id]

  if user.recipes.blank?
    Rails.logger.debug 'ユーザーのレシピがありません'
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
      body: comment_body
    )
    Notification.create_comment_notification(other_user_comment)

    other_user_favorite = other_user.favorites.find_or_create_by(
      recipe_id: user.recipes.sample.id
    )
    Notification.create_favorite_notification(other_user_favorite)

    other_user_relationship = other_user.relationships.find_or_create_by(
      follow_id: user.id
    )
    Notification.create_relationship_notification(other_user_relationship)

    notification_creation_time -= 1
    Rails.logger.debug notification_creation_time.zero? ? '通知作成完了' : "あと#{notification_creation_time}回"
  end
end

def create_recipe_of_one_user(recipe_creation_time, user_id)
  Rails.logger.debug "#{user_id}のレシピを#{recipe_creation_time}回作成"

  recipe_creation_time.times do
    recipe_title = Faker::Lorem.words(number: rand(1..10)).join(' ')[0..29]
    recipe_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..8)).join(' ')}
    TEXT
    recipe_image = File.open("./db/fixtures/recipe/recipe_sample_#{rand(1..30)}.jpg")

    User.find(user_id).recipes.create!(
      title: recipe_title,
      body: recipe_body[0..1999],
      recipe_image: recipe_image,
      tag_list: Faker::Lorem.words(number: rand(1..5)).join(', ')
    )

    recipe_creation_time -= 1
    Rails.logger.debug recipe_creation_time.zero? ? "#{user_id}のレシピ作成完了" : "あと#{recipe_creation_time}回"
  end
end

def create_comment_of_one_user(comment_creation_time, user_id)
  Rails.logger.debug "#{user_id}のコメントを#{comment_creation_time}回作成"

  comment_creation_time.times do
    comment_body = <<~TEXT
      #{Faker::Lorem.paragraphs(number: rand(1..5)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..10)).join(' ')}
      #{Faker::Lorem.paragraphs(number: rand(1..3)).join(' ')}
    TEXT

    User.find(user_id).comments.create!(
      body: comment_body[0..499],
      recipe_id: Recipe.ids.sample
    )

    comment_creation_time -= 1
    Rails.logger.debug comment_creation_time.zero? ? "#{user_id}のコメント作成完了" : "あと#{comment_creation_time}回"
  end
end

def create_favorite_of_one_user(favorite_creation_time, user_id)
  Rails.logger.debug "#{user_id}のいいねを#{favorite_creation_time}回作成"

  favorite_creation_time.times do
    User.find(user_id).favorites.find_or_create_by(recipe_id: Recipe.ids.sample)

    favorite_creation_time -= 1
    Rails.logger.debug favorite_creation_time.zero? ? "#{user_id}のいいね作成完了" : "あと#{favorite_creation_time}回"
  end
end

# create_characteristic_user_recipe_comment
# create_user(time)
# create_relationship(time)
# create_recipe(time)
# create_comment(time)
# create_favorite(time)
# update_recipe(time)
# create_notification_of_one_user(time, user_id)
# create_recipe_of_one_user(time, user_id)
# create_comment_of_one_user(time, user_id)
# create_favorite_of_one_user(time, user_id)
