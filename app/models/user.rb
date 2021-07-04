class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  attachment :profile_image

  before_destroy :remove_image

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :recipes, dependent: :destroy

  has_many :relationships
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'

  has_many :followings, through: :relationships, source: :follow
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :commented_recipes, -> { distinct }, through: :comments, source: :recipe
  has_many :favored_recipes, through: :favorites, source: :recipe

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

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

  validates :username, presence: true

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
      user.username = "ゲスト"
    end
  end

  def create_follow_notification!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def feed
    Recipe.where("user_id IN (?) OR user_id = ?", following_ids, id)
  end

  def recipes_favorites_count
    recipes_favorites_count = 0
    recipes.each do |recipe|
      recipes_favorites_count += recipe.favorites.size
    end
    recipes_favorites_count
  end

  private
    def self.ransackable_attributes(auth_object = nil)
      %w(username profile followers_count followings_count recipes_count)
    end

    def remove_image
      user_image.remove!
    end
end
