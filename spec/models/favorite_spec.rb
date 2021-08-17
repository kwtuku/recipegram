require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it { is_expected.to validate_uniqueness_of(:recipe_id).scoped_to(:user_id) }
end
