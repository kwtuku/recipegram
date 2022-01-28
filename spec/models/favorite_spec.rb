require 'rails_helper'

RSpec.describe Favorite, type: :model do
  subject { described_class.new(recipe_id: create(:recipe, :no_image).id, user_id: create(:user, :no_image).id) }

  it { is_expected.to validate_uniqueness_of(:recipe_id).scoped_to(:user_id) }
end
