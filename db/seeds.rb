User.create!(username:  "山田 太郎",
  email: "example@example.com",
  password:              "ffffff",
  password_confirmation: "ffffff")

99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@example.com"
password = "ffffff"
User.create!(username:  name,
    email: email,
    password:              password,
    password_confirmation: password)
end
