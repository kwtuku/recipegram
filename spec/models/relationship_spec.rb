require 'rails_helper'

RSpec.describe Relationship, type: :model do
  it do
    relationship = described_class.new(follow_id: create(:user).id, user_id: create(:user).id)
    expect(relationship).to validate_uniqueness_of(:follow_id).scoped_to(:user_id)
  end
end
