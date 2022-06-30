Rails.logger = Logger.new($stdout)
Faker::Config.locale = :en

def generate_paragraphs(max_chars_count)
  chars_count = rand(10..max_chars_count)
  new_lines_count = rand(1..(chars_count / 50)) || 0
  not_new_line_chars_count = chars_count - new_lines_count * 2

  rands = Array.new(new_lines_count) { rand(1..(not_new_line_chars_count - 1)) }
  rands.push(0, not_new_line_chars_count).sort!
  paragraph_chars_counts = rands.drop(1).zip(rands).map { |a, b| a - b }.delete_if(&:zero?)
  paragraphs = paragraph_chars_counts.map do |paragraph_chars_count|
    Faker::Lorem.paragraph_by_chars(number: paragraph_chars_count, supplemental: false)
  end

  paragraphs.join("\r\n")
end

def create_long_word_user_recipe_comment
  user = User.find_by(email: 'long@example.com')
  joined_extension = UserImageUploader.new.extension_allowlist.join(',')
  user_image_paths = Dir.glob("db/fixtures/files/users/*.{#{joined_extension}}")
  user ||= User.create!(
    username: "very_long_w#{'o' * 2}rd",
    nickname: "very_long_w#{'o' * 17}rd",
    email: 'long@example.com',
    password: Rails.env.production? ? Rails.application.credentials.seed[:user_password] : 'fffffr',
    profile: "very_long_w#{'o' * 487}rd",
    user_image: File.open(user_image_paths.sample)
  )
  Rails.logger.debug 'ユーザーを作成完了'

  recipe = user.recipes.create!(
    title: "very_long_w#{'o' * 17}rd",
    body: "very_long_w#{'o' * 1987}rd",
    tag_list: Array.new(5) { "#{SecureRandom.hex(7)}a" }.join(',')
  )
  Rails.logger.debug 'レシピを作成完了'

  user.comments.create!(
    recipe_id: recipe.id,
    body: "very_long_w#{'o' * 487}rd"
  )
  Rails.logger.debug 'コメントを作成完了'
end

def create_users(count)
  Rails.logger.debug "ユーザーを#{count}回作成"

  joined_extension = UserImageUploader.new.extension_allowlist.join(',')
  user_image_paths = Dir.glob("db/fixtures/files/users/*.{#{joined_extension}}")

  count.times do
    User.create!(
      username: SecureRandom.urlsafe_base64(rand(7..11)).downcase,
      nickname: Faker::Lorem.words(number: rand(1..5)).join(' ')[0..29],
      email: "#{SecureRandom.urlsafe_base64}@example.com",
      password: Rails.env.production? ? Rails.application.credentials.seed[:user_password] : 'fffffr',
      profile: rand > 0.3 ? generate_paragraphs(500) : nil,
      user_image: rand > 0.3 ? File.open(user_image_paths.sample) : nil
    )

    count -= 1
    Rails.logger.debug "あと#{count}回" unless count.zero?
  end

  Rails.logger.debug 'ユーザー作成完了'
end

def create_relationships(count)
  Rails.logger.debug "フォローを#{count}回作成"

  user_ids = User.ids
  count.times do
    user_pair = user_ids.sample(2)
    Relationship.find_or_create_by!(follow_id: user_pair[0], user_id: user_pair[1])

    count -= 1
    Rails.logger.debug "あと#{count}回" unless count.zero?
  end

  Rails.logger.debug 'フォロー作成完了'
end

def create_recipes(count, user_id = nil)
  Rails.logger.debug user_id ? "#{user_id}のレシピを#{count}回作成" : "レシピを#{count}回作成"

  joined_extension = RecipeImageUploader.new.extension_allowlist.join(',')
  recipe_image_paths = Dir.glob("db/fixtures/files/recipes/*.{#{joined_extension}}")

  count.times do
    user = user_id ? User.find(user_id) : User.order('RANDOM()').first

    image_attributes = Array.new(rand(1..10)) do |i|
      [i, { 'position' => i + 1, 'resource' => File.open(recipe_image_paths.sample) }]
    end.to_h

    RecipeForm.new(
      {
        title: Faker::Lorem.words(number: rand(1..5)).join(' ')[0..29],
        body: generate_paragraphs(2000),
        tag_list: Faker::Lorem.words(number: rand(6)).join(','),
        image_attributes: image_attributes
      },
      recipe: user.recipes.new
    ).save

    count -= 1
    Rails.logger.debug "あと#{count}回" unless count.zero?
  end

  Rails.logger.debug user_id ? "#{user_id}のレシピ作成完了" : 'レシピ作成完了'
end

def create_comments(count, user_id = nil)
  Rails.logger.debug user_id ? "#{user_id}のコメントを#{count}回作成" : "コメントを#{count}回作成"

  user_ids = user_id ? [user_id] : User.ids
  recipe_ids = Recipe.ids
  count.times do
    Comment.create!(recipe_id: recipe_ids.sample, user_id: user_ids.sample, body: generate_paragraphs(500))

    count -= 1
    Rails.logger.debug "あと#{count}回" unless count.zero?
  end

  Rails.logger.debug user_id ? "#{user_id}のコメント作成完了" : 'コメント作成完了'
end

def create_favorites(count, user_id = nil)
  Rails.logger.debug user_id ? "#{user_id}のいいねを#{count}回作成" : "いいねを#{count}回作成"

  user_ids = user_id ? [user_id] : User.ids
  recipe_ids = Recipe.ids
  count.times do
    Favorite.find_or_create_by!(recipe_id: recipe_ids.sample, user_id: user_ids.sample)

    count -= 1
    Rails.logger.debug "あと#{count}回" unless count.zero?
  end

  Rails.logger.debug user_id ? "#{user_id}のいいね作成完了" : 'いいね作成完了'
end

def update_recipes(count)
  Rails.logger.debug "レシピを#{count}回更新"

  Recipe.all.sample(count).each do |recipe|
    recipe.update!(
      title: Faker::Lorem.words(number: rand(1..5)).join(' ')[0..29],
      body: generate_paragraphs(2000),
      tag_list: Faker::Lorem.words(number: rand(6)).join(',')
    )

    count -= 1
    Rails.logger.debug "#{recipe.id}を更新"
    Rails.logger.debug "あと#{count}回" unless count.zero?
  end

  Rails.logger.debug 'レシピ更新完了'
end

def create_notifications(count, user_id)
  Rails.logger.debug "#{user_id}の通知を#{count}回作成"

  user = User.find(user_id)
  user_recipe_ids = user.recipe_ids
  user_commented_recipe_ids = user.commented_recipe_ids
  other_user_ids = User.where.not(id: user_id).ids
  not_user_recipe_ids = Recipe.where.not(user_id: user_id).ids
  if user_commented_recipe_ids.blank?
    Comment.create!(recipe_id: not_user_recipe_ids.sample, user_id: user_id, body: generate_paragraphs(500))
  end

  count.times do
    case rand
    when 0..0.25
      recipe_id = user_recipe_ids.sample
      other_user_id = other_user_ids.sample
      notifiable = Comment.create!(recipe_id: recipe_id, user_id: other_user_id, body: generate_paragraphs(500))
    when 0.25..0.5
      recipe_id = user_commented_recipe_ids.sample
      other_user_id = other_user_ids.sample
      notifiable = Comment.create!(recipe_id: recipe_id, user_id: other_user_id, body: generate_paragraphs(500))
    when 0.5..0.75
      notifiable = Favorite.find_or_create_by!(recipe_id: user_recipe_ids.sample, user_id: other_user_ids.sample)
    when 0.75..1
      notifiable = Relationship.find_or_create_by!(follow_id: user_id, user_id: other_user_ids.sample)
    end

    Notification.create!(notifiable_id: notifiable.id, receiver_id: user_id, notifiable_type: notifiable.class.name)

    count -= 1
    Rails.logger.debug "あと#{count}回" unless count.zero?
  end

  Rails.logger.debug '通知作成完了'
end

# create_long_word_user_recipe_comment
# create_users(count)
# create_relationships(count)
# create_recipes(count, blank_or_user_id)
# create_comments(count, blank_or_user_id)
# create_favorites(count, blank_or_user_id)
# update_recipes(count)
# create_notifications(count, user_id)
