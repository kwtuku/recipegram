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
  validate :validate_tag

  def others(count)
    others = Recipe.eager_load(:favorites, :comments).where(user_id: user_id).order(id: :DESC) - [self]
    others.first(count)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title body]
  end

  def self.ransortable_attributes(_auth_object = nil)
    %w[comments_count favorites_count updated_at]
  end

  private

  def remove_image
    recipe_image.remove!
  end

  TAG_MAX_COUNT = 5
  def validate_tag
    if tag_list.size > TAG_MAX_COUNT
      return errors.add(:tag_list, :too_many_tags, message: "は#{TAG_MAX_COUNT}つ以下にしてください")
    end

    tag_list.each do |tag_name|
      tag = Tag.new(name: tag_name)
      tag.validate_name
      tag.errors.messages[:name].each { |message| errors.add(:tag_list, message) }
    end
  end
end
