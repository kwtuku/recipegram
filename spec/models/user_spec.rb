require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  it 'is valid with a username, email and password' do
    expect(@user).to be_valid
  end

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  describe 'feed' do
    let(:michael) { create(:user,  :with_recipes) }
    let(:archer) { create(:user,  :with_recipes) }
    let(:lana) { create(:user,  :with_recipes) }
    before { michael.relationships.create!(follow_id: lana.id) }

    it 'has following user recipes' do
      lana.recipes.each do |recipe_following|
        expect(michael.feed.include?(recipe_following)).to be_truthy
      end
    end
    it 'has self recipes' do
      michael.recipes.each do |recipe_self|
        expect(michael.feed.include?(recipe_self)).to be_truthy
      end
    end
    it 'does not have unfollowing user recipes' do
      archer.recipes.each do |recipe_unfollowed|
        expect(michael.feed.include?(recipe_unfollowed)).to be_falsy
      end
    end
  end
end
