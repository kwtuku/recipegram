require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @alice = build(:user)
  end

  it 'is valid with a username, email and password' do
    expect(@alice).to be_valid
  end

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  describe 'feed' do
    let(:alice) { create(:user,  :with_recipes) }
    let(:bob) { create(:user,  :with_recipes) }
    let(:carol) { create(:user,  :with_recipes) }
    before { alice.relationships.create!(follow_id: bob.id) }

    it 'has self recipes' do
      alice.recipes.each do |recipe_self|
        expect(alice.feed.include?(recipe_self)).to eq true
      end
    end
    it 'has following user recipes' do
      bob.recipes.each do |recipe_following|
        expect(alice.feed.include?(recipe_following)).to eq true
      end
    end
    it 'does not have unfollowing user recipes' do
      carol.recipes.each do |recipe_unfollowed|
        expect(alice.feed.include?(recipe_unfollowed)).to eq false
      end
    end
  end
end
