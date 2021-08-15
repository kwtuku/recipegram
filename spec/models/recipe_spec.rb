require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(30) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_most(2000) }
  it { is_expected.to validate_presence_of(:recipe_image) }
end
