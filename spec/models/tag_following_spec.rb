require 'rails_helper'

RSpec.describe TagFollowing, type: :model do
  it do
    tag_following = described_class.new(follower_id: create(:user).id, tag_id: create(:tag).id)
    expect(tag_following).to validate_uniqueness_of(:follower_id).scoped_to(:tag_id)
  end
end
