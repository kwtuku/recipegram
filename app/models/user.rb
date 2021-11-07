class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  before_save { self.username = username.downcase }
  before_destroy :remove_image

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, foreign_key: :receiver_id, inverse_of: 'receiver', dependent: :destroy
  has_many :recipes, dependent: :destroy

  has_many :relationships, dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', inverse_of: 'follow',
                                      dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :commented_recipes, through: :comments, source: :recipe
  has_many :favored_recipes, through: :favorites, source: :recipe

  mount_uploader :user_image, UserImageUploader

  ransacker :followers_count do
    query = '(SELECT COUNT(*) FROM relationships WHERE relationships.follow_id = users.id)'
    Arel.sql(query)
  end
  ransacker :recipes_count do
    query = '(SELECT COUNT(*) FROM recipes WHERE recipes.user_id = users.id)'
    Arel.sql(query)
  end

  RESERVED_WORDS = %w[
    sign_in
    sign_out
    password
    cancel
    sign_up
    edit
    confirm_destroy
    guest_sign_in
  ].freeze
  USERNAME_MAX_LENGTH = 15
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_-]+\z/.freeze

  validates :nickname, length: { maximum: 30 }, presence: true
  validates :profile, length: { maximum: 500 }
  validates :username,
            exclusion: { in: RESERVED_WORDS },
            format: { with: VALID_USERNAME_REGEX },
            length: { in: 1..USERNAME_MAX_LENGTH },
            presence: true,
            uniqueness: { case_sensitive: false }

  def already_favored?(recipe)
    favorites.exists?(recipe_id: recipe.id)
  end

  def follow(other_user)
    relationships.find_or_create_by(follow_id: other_user.id) if self != other_user
  end

  def unfollow(other_user)
    relationship = relationships.find_by(follow_id: other_user.id)
    relationship&.destroy
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def followers_you_follow(you)
    followers & you.followings
  end

  def feed
    Recipe.includes(:user, :comments, :favorites)
      .where('user_id IN (?) OR user_id = ?', following_ids, id).order(updated_at: :DESC)
  end

  def recommended_recipes
    Recipe.all.eager_load(:user, :comments, :favorites).shuffle - feed
  end

  def home_recipes
    feed + recommended_recipes
  end

  def recommended_users
    User.all - [self] - followings
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.username = 'guest'
      user.nickname = 'ゲスト'
    end
  end

  def self.generate_username
    tmp_username = SecureRandom.urlsafe_base64(11).downcase
    User.vary_from_usernames!(tmp_username)
  end

  def self.vary_from_usernames!(tmp_username)
    username = tmp_username
    username = SecureRandom.urlsafe_base64(11).downcase while User.exists?(username: username)
    username
  end

  def to_param
    username
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[nickname profile]
  end

  def self.ransortable_attributes(_auth_object = nil)
    %w[followers_count followings_count recipes_count]
  end

  private

  def remove_image
    user_image.remove!
  end
end
