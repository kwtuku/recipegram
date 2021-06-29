class Recipe < ApplicationRecord
  attachment :image

  before_destroy :remove_image

  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  mount_uploader :recipe_image, RecipeImageUploader

  with_options presence: true do
    validates :title
    validates :body
    validates :recipe_image
  end

  def create_favorite_notification!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and recipe_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])

    if temp.blank?
      notification = current_user.active_notifications.new(
        recipe_id: id,
        visited_id: user_id,
        action: 'favorite'
      )

      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end

      notification.save if notification.valid?
    end
  end

  private
    def self.ransackable_attributes(auth_object = nil)
      %w(title body)
    end

    def remove_image
      recipe_image.remove!
    end
end
