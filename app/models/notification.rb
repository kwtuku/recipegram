class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :receiver, class_name: 'User'

  default_scope -> { order(created_at: :desc) }

  def self.create_comment_notification(comment)
    comment_notification_receiver_ids(comment).each do |receiver_id|
      Notification.create(
        notifiable_id: comment.id,
        receiver_id: receiver_id,
        notifiable_type: comment.class.name
      )
    end
  end

  def self.comment_notification_receiver_ids(comment)
    comment_user_id = comment.user_id
    comment_user_ids = comment.recipe.comments.map(&:user_id).uniq
    recipe_user_id = comment.recipe.user_id

    if comment_user_id == recipe_user_id
      comment_user_ids - [comment_user_id]
    else
      comment_user_ids - [comment_user_id] | [recipe_user_id]
    end
  end

  def self.create_relationship_notification(relationship)
    Notification.create(
      notifiable_id: relationship.id,
      receiver_id: relationship.follow_id,
      notifiable_type: relationship.class.name
    )
  end

  def self.create_favorite_notification(favorite)
    return if favorite.recipe.user_id == favorite.user_id

    Notification.create(
      notifiable_id: favorite.id,
      receiver_id: favorite.recipe.user_id,
      notifiable_type: favorite.class.name
    )
  end
end
