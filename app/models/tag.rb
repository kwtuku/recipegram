class Tag < ActsAsTaggableOn::Tag
  before_save { self.name = name.downcase }

  has_many :tag_followings, dependent: :destroy
  has_many :followers, through: :tag_followings, source: :follower
  has_many :recipes, through: :taggings, source: :taggable, source_type: :Recipe

  validate :validate_name

  TAG_NAME_MAX_LENGTH = 20
  TAG_NAME_REGEX = /\A[\w一-龠々ぁ-ヶー]+\Z/.freeze

  def validate_name
    errors.add(:name, "は#{TAG_NAME_MAX_LENGTH}文字以内で入力してください") if name.length > TAG_NAME_MAX_LENGTH
    errors.add(:name, 'はひらがなまたは、全角のカタカナ、漢字、半角の英数字のみが使用できます') unless name.match?(TAG_NAME_REGEX)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name taggings_count]
  end

  def self.ransortable_attributes(_auth_object = nil)
    %w[taggings_count]
  end
end
