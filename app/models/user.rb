class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  before_validation { self.username = username.downcase }
  before_destroy :remove_image

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, foreign_key: :receiver_id, dependent: :destroy
  has_many :recipes, dependent: :destroy

  has_many :relationships, dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy

  has_many :followings, through: :relationships, source: :follow
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :commented_recipes, through: :comments, source: :recipe
  has_many :favored_recipes, through: :favorites, source: :recipe

  mount_uploader :user_image, UserImageUploader

  ransacker :followers_count do
    query = '(SELECT COUNT(*) FROM relationships WHERE relationships.follow_id = users.id)'
    Arel.sql(query)
  end
  ransacker :followings_count do
    query = '(SELECT COUNT(*) FROM relationships WHERE relationships.user_id = users.id)'
    Arel.sql(query)
  end
  ransacker :recipes_count do
    query = '(SELECT COUNT(*) FROM recipes WHERE recipes.user_id = users.id)'
    Arel.sql(query)
  end

  validates :nickname, presence: true
  RESERVED_WORDS = %w(
    sign_in
    sign_out
    password
    cancel
    sign_up
    edit
    guest_sign_in
  )
  USERNAME_MAX_LENGTH = 15
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9[-][_]]+\z/
  validates :username,
            exclusion: { in: RESERVED_WORDS },
            format: { with: VALID_USERNAME_REGEX },
            length: { in: 1..USERNAME_MAX_LENGTH },
            presence: true,
            uniqueness: { case_sensitive: false }

  def already_favored?(recipe)
    self.favorites.exists?(recipe_id: recipe.id)
  end

  def follow(other_user)
    if self != other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.username = 'guest'
      user.nickname = 'ゲスト'
    end
  end

  def feed
    Recipe.where("user_id IN (?) OR user_id = ?", following_ids, id)
  end

  def recipes_favorites_count
    recipes_favorites_count = 0
    recipes.eager_load(:favorites).each do |recipe|
      recipes_favorites_count += recipe.favorites.size
    end
    recipes_favorites_count
  end

  def followers_you_follow(current_user)
    followers & current_user.followings
  end

  def recommended_users
    User.all - [self] - self.followings
  end

  def self.generate_username
    tmp_username = SecureRandom.urlsafe_base64(11).downcase
    username = User.vary_from_usernames!(tmp_username)
  end

  def self.vary_from_usernames!(tmp_username)
    username = tmp_username
    while User.exists?(username: username)
      username = SecureRandom.urlsafe_base64(11).downcase
    end
    username
  end

  def to_param
    username
  end

  private
    def self.ransackable_attributes(auth_object = nil)
      %w(nickname profile followers_count followings_count recipes_count)
    end

    def remove_image
      user_image.remove!
    end
end
