require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    before do
      @alice = build(:user)
    end

    it 'is valid with a username, email and password' do
      expect(@alice).to be_valid
    end

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe 'feed' do
    let(:alice) { create(:user, :has_5_recipes, :no_image) }
    let(:bob) { create(:user, :has_5_recipes, :no_image) }
    let(:carol) { create(:user, :has_5_recipes, :no_image) }
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

  describe 'followers_you_follow' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:carol) { create :user, :no_image }
    let(:dave) { create :user, :no_image }
    let(:ellen) { create :user, :no_image }
    let(:frank) { create :user, :no_image }
    before do
      alice.relationships.create!(follow_id: carol.id)
      alice.relationships.create!(follow_id: dave.id)
      carol.relationships.create!(follow_id: bob.id)
      dave.relationships.create!(follow_id: bob.id)
      ellen.relationships.create!(follow_id: bob.id)
      frank.relationships.create!(follow_id: bob.id)
    end

    it 'has following users' do
      expect(bob.followers_you_follow(alice)).to include carol, dave
    end

    it 'does not have unfollowing users' do
      expect(bob.followers_you_follow(alice)).to_not include ellen, frank
    end
  end
end
