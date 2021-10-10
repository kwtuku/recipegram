class Recipe < ApplicationRecord
  before_destroy :remove_image

  acts_as_taggable_on :tags

  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  mount_uploader :recipe_image, RecipeImageUploader

  ransacker :comments_count do
    query = '(SELECT COUNT(*) FROM comments WHERE comments.recipe_id = recipes.id)'
    Arel.sql(query)
  end
  ransacker :favorites_count do
    query = '(SELECT COUNT(*) FROM favorites WHERE favorites.recipe_id = recipes.id)'
    Arel.sql(query)
  end

  validates :title, length: { maximum: 30 }, presence: true
  validates :body, length: { maximum: 2000 }, presence: true
  validates :recipe_image, presence: true

  def others(count)
    others = Recipe.eager_load(:favorites, :comments).where(user_id: user_id).order(id: :DESC) - [self]
    others.first(count)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title body updated_at comments_count favorites_count]
  end

  private

  def remove_image
    recipe_image.remove!
  end
end
