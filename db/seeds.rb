password = "ffffff"
sample_imgs = %w(
  ウキウキな仔犬.jpg
  おはようキバタン.jpg
  ご機嫌のオカメインコ.jpg
  ニヒルなキバタン.jpg
  呼ぶネコ.jpg
  初めましてイワシャコです.jpg
  分かんなくなった柴犬.jpg
)

User.create!(
  username:              "山田 太郎",
  email:                 "example@example.com",
  password:              password,
  password_confirmation: password,
  profile:               Faker::Lorem.paragraphs,
  user_image:            File.open("./public/images/seeds/#{sample_imgs[rand(7)]}"),
)

user_creation_time = 10
user_creation_time.times do |n|
  username  = Faker::Name.unique.name
  email = "example#{n+1}@example.com"
  profile = Faker::Lorem.paragraphs
  user_image = File.open("./public/images/seeds/#{sample_imgs[rand(7)]}")
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

total_user_creation_time = user_creation_time + 1
users.each do |user|
  rand(total_user_creation_time).times do
    followed = users[rand(total_user_creation_time)]
    unless user.id == followed.id
      user.relationships.find_or_create_by(follow_id: followed.id)
    end
  end
end
