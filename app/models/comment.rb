class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user

  has_many :notifications, dependent: :destroy

  validates :body, presence: true

  def create_comment_notification!(current_user, comment_id, recipe_id)
    temp_ids = Comment.select(:user_id).where(recipe_id: recipe_id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_comment_notification!(current_user, comment_id, recipe_id, temp_id['user_id'])
    end

    save_comment_notification!(current_user, comment_id, recipe_id, recipe.user.id)
  end

  def save_comment_notification!(current_user, comment_id, recipe_id, visited_id)
    notification = current_user.active_notifications.new(
      recipe_id: recipe_id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )

    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end

    notification.save if notification.valid?
  end
end
