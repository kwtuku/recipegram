Rails.logger = Logger.new($stdout)

User.find_each do |user|
  user.user_image&.recreate_versions!
  Rails.logger.debug "ユーザー#{user.id}の画像を再作成"
rescue StandardError
  Rails.logger.debug "ユーザー#{user.id}の画像の再作成に失敗！"
end
