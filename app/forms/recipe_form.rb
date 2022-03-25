class RecipeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :title, :body, :tag_list
  attr_reader :images

  attribute :image_attributes

  delegate :persisted?, to: :recipe

  validates :title, presence: true
  validates :body, presence: true
  validate :validate_images_count

  MAX_IMAGES_COUNT = 10
  MIN_IMAGES_COUNT = 1

  def initialize(attributes = nil, recipe: Recipe.new)
    @recipe = recipe
    @images = recipe.images
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      recipe.update!(title: title, body: body, tag_list: tag_list)

      destroying_images = images.where(id: destroying_image_ids)
      destroying_images.delete_all if destroying_images.present?

      updating_images = images.where(id: updating_image_ids).order(:id)
      updating_images.zip(updating_image_positions) do |image, position|
        image.position = position
        image.save!(context: :recipe_form_save)
      end

      new_image_attributes_collection.each do |attrs|
        images.new(resource: attrs['resource'], position: attrs['position']).save!(context: :recipe_form_save)
      end
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.each { |error| errors.add(error.attribute.to_sym, error.type.to_sym, message: error.message) }
    false
  end

  def to_model
    recipe
  end

  private

  attr_reader :recipe

  def default_attributes
    image_attributes = images.map do |image|
      [image.id, { **image.attributes.slice('id', 'position'), '_destroy' => 'false' }]
    end.to_h

    {
      title: recipe.title,
      body: recipe.body,
      tag_list: recipe.tag_list,
      image_attributes: image_attributes
    }
  end

  def validate_images_count
    images_count = images.size - destroying_image_ids.size + new_image_attributes_collection.size

    if images_count < MIN_IMAGES_COUNT
      errors.add(:image_attributes, :require_images, message: "は#{MIN_IMAGES_COUNT}枚以上必要です")
    end
    return if images_count <= MAX_IMAGES_COUNT

    errors.add(:image_attributes, :too_many_images, message: "は#{MAX_IMAGES_COUNT}枚以下にしてください")
  end

  def sanitized_image_attributes_collection
    return [] if image_attributes.nil?

    recipe_image_ids = recipe.image_ids
    image_attributes.values
      .reject { |attrs| attrs['id'] && recipe_image_ids.exclude?(attrs['id'].to_i) }
      .reject { |attrs| attrs['_destroy'] && !attrs['id'] }
      .reject { |attrs| attrs['_destroy'] == 'false' && !attrs['position'] }
  end

  def updating_image_attributes_collection
    sanitized_image_attributes_collection.filter { |attrs| attrs['_destroy'] == 'false' }
  end

  def updating_image_ids
    updating_image_attributes_collection.map { |attrs| attrs['id'] }
  end

  def updating_image_positions
    updating_image_attributes_collection.sort_by { |attrs| attrs['id'].to_i }.map { |attrs| attrs['position'] }
  end

  def new_image_attributes_collection
    sanitized_image_attributes_collection.filter { |attrs| attrs['resource'] }
  end

  def destroying_image_ids
    sanitized_image_attributes_collection.filter { |attrs| attrs['_destroy'] == 'true' }.map { |attrs| attrs['id'] }
  end
end
