require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it do
    favorite = described_class.new(recipe_id: create(:recipe).id, user_id: create(:user).id)
    expect(favorite).to validate_uniqueness_of(:recipe_id).scoped_to(:user_id)
  end
end
