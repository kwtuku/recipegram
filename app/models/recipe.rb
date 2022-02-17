class Recipe < ApplicationRecord
  before_destroy :remove_image

  acts_as_taggable_on :tags

  belongs_to :user

  counter_culture :user

  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  mount_uploader :recipe_image, RecipeImageUploader

  validates :title, length: { maximum: 30 }, presence: true
  validates :body, length: { maximum: 2000 }, presence: true
  validates :recipe_image, presence: true
  validate :validate_tag

  TAG_MAX_COUNT = 5

  def others(count)
    user.recipes.where.not(id: id).order(id: :DESC).limit(count)
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
