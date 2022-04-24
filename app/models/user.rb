class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  before_save { self.username = username.downcase }

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, foreign_key: :receiver_id, inverse_of: 'receiver', dependent: :destroy
  has_many :recipes, dependent: :destroy

  has_many :relationships, dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', inverse_of: 'follow',
                                      dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :favored_recipes, through: :favorites, source: :recipe

  has_many :tag_followings, foreign_key: 'follower_id', inverse_of: 'follower', dependent: :destroy
  has_many :following_tags, through: :tag_followings, source: :tag

  mount_uploader :user_image, UserImageUploader

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

  def followers_you_follow(you)
    followers.where(id: you.following_ids)
  end

  def feed
    Recipe.where(id: Recipe.where('user_id IN (?) OR user_id = ?', followings.select(:id), id).select(:id))
      .or(Recipe.where(id: Recipe.joins(:tags).merge(Tag.where(id: following_tags.select(:id))).select(:id)))
  end

  def recommended_users(count)
    User.where(id: User.select(:id).where.not(id: following_ids.push(id)).order('RANDOM()').limit(count))
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
    %w[followers_count recipes_count]
  end

  def commented_recipes
    Recipe.joins(:comments).where(comments: { id: comments.group(:recipe_id).select('MAX(id)') })
  end
end
