require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:nickname) }
    it { is_expected.to validate_length_of(:nickname).is_at_most(30) }
    it { is_expected.to validate_length_of(:profile).is_at_most(500) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    describe 'username' do
      let(:reserved_words) do
        %w[
          sign_in
          sign_out
          password
          cancel
          sign_up
          edit
          guest_sign_in
        ]
      end

      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_length_of(:username).is_at_most(15) }
      it { is_expected.to validate_exclusion_of(:username).in_array(reserved_words) }

      it 'is invalid with invalid formats' do
        invalid_usernames = %W[
          i_am_alice!
          i_am_alice.
          i/am/alice
          ありす
          アリス
          愛凜翠
          #{'i am alice'}
          #{' alice'}
          #{'alice '}
        ]
        alice = build(:user)
        invalid_usernames.each do |invalid_username|
          alice.username = invalid_username
          expect(alice).to be_invalid
          expect(alice.errors).to be_of_kind(:username, :invalid)
        end
      end

      it 'is valid with valid formats' do
        valid_usernames = %w[
          aaa
          AAA
          111
          ---
          ___
          aA1-_
        ]
        alice = build(:user)
        valid_usernames.each do |valid_username|
          alice.username = valid_username
          expect(alice).to be_valid
        end
      end

      it 'is saved as lower case' do
        alice = create(:user, username: 'ALICE')
        expect(alice.username).to eq 'alice'
        alice.update(username: 'I_aM-AliCe')
        expect(alice.username).to eq 'i_am-alice'
      end

      it 'is not case sensitive' do
        create(:user, username: 'alice')
        bob = build_stubbed(:user, username: 'ALICE')
        expect(bob).to be_invalid
        expect(bob.errors).to be_of_kind(:username, :taken)
      end

      it 'is invalid when username is already taken' do
        create(:user, username: 'alice')
        bob = build_stubbed(:user, username: 'alice')
        expect(bob).to be_invalid
        expect(bob.errors).to be_of_kind(:username, :taken)
      end
    end
  end

  describe 'already_favored?(recipe)' do
    let(:alice) { create(:user) }
    let(:favored_recipe) { create(:recipe) }
    let!(:not_favored_recipe) { create(:recipe) }

    before do
      alice.favorites.create!(recipe_id: favored_recipe.id)
    end

    context 'when alice already favored a recipe' do
      it 'returns true' do
        expect(alice.already_favored?(favored_recipe)).to eq true
      end
    end

    context 'when alice does not favor a recipe' do
      it 'returns false' do
        expect(alice.already_favored?(not_favored_recipe)).to eq false
      end
    end
  end

  describe 'follow(other_user)' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }

    it 'increases relationship count' do
      expect do
        alice.follow(bob)
      end.to change(alice.followings, :count).by(1).and change(bob.followers, :count).by(1)
    end
  end

  describe 'unfollow(other_user)' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }

    before { alice.relationships.create!(follow_id: bob.id) }

    it 'decreases relationship count' do
      expect do
        alice.unfollow(bob)
      end.to change(alice.followings, :count).by(-1).and change(bob.followers, :count).by(-1)
    end
  end

  describe 'followers_you_follow(you)' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }
    let(:carol) { create(:user) }
    let(:dave) { create(:user) }
    let(:ellen) { create(:user) }

    before do
      alice.relationships.create!(follow_id: carol.id)
      alice.relationships.create!(follow_id: dave.id)
      carol.relationships.create!(follow_id: bob.id)
      ellen.relationships.create!(follow_id: bob.id)
    end

    it 'has following user which follows object user' do
      expect(bob.followers_you_follow(alice)).to include carol
    end

    it 'does not have following user which does not follow object user' do
      expect(bob.followers_you_follow(alice)).not_to include dave
    end

    it 'does not have unfollowing user' do
      expect(bob.followers_you_follow(alice)).not_to include ellen
    end
  end

  describe 'feed' do
    let(:alice) { create(:user, :has_5_recipes) }
    let(:bob) { create(:user, :has_5_recipes) }
    let(:carol) { create(:user, :has_5_recipes) }
    let(:following_tag) { create(:tag) }
    let(:not_following_tag) { create(:tag) }

    before do
      alice.relationships.create!(follow_id: bob.id)
      create(:recipe, tag_list: following_tag.name)
      create(:recipe, tag_list: not_following_tag.name)
      alice.tag_followings.create!(tag_id: following_tag.id)
      bob.recipes.order('RANDOM()').limit(1).update(tag_list: following_tag.name)
    end

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
      carol.recipes.each do |recipe_unfollowing|
        expect(alice.feed.include?(recipe_unfollowing)).to eq false
      end
    end

    it 'has following tag recipes' do
      Recipe.tagged_with(following_tag.name).each do |recipe_following|
        expect(alice.feed.include?(recipe_following)).to eq true
      end
    end

    it 'does not have unfollowing tag recipes' do
      Recipe.tagged_with(not_following_tag.name).each do |recipe_not_following|
        expect(alice.feed.include?(recipe_not_following)).to eq false
      end
    end

    it 'has correct count' do
      expect(alice.feed.size).to eq 11
    end
  end

  describe 'self.guest' do
    context 'when guest exists' do
      before { create(:user, email: 'guest@example.com') }

      it 'is valid' do
        expect(described_class.guest).to be_valid
      end

      it 'does not increase user count' do
        expect do
          described_class.guest
        end.to change(described_class, :count).by(0)
      end
    end

    context 'when guest dose not exist' do
      it 'is valid' do
        expect(described_class.guest).to be_valid
      end

      it 'increases user count' do
        expect do
          described_class.guest
        end.to change(described_class, :count).by(1)
      end
    end
  end

  describe 'self.generate_username' do
    before { create_list(:user, 10) }

    it 'is saved as lower-case' do
      username = described_class.generate_username
      expect(username).to eq username.downcase
    end

    it 'generates username different from existing usernames' do
      username = described_class.generate_username
      expect(described_class.all.pluck(:username)).not_to include username
    end
  end

  describe 'self.vary_from_usernames!(tmp_username)' do
    before { create_list(:user, 10) }

    it 'is saved as lower-case' do
      tmp_username = described_class.all.sample.username
      username = described_class.vary_from_usernames!(tmp_username)
      expect(username).to eq username.downcase
    end

    it 'makes tmp_username different from existing usernames' do
      tmp_username = described_class.all.sample.username
      username = described_class.vary_from_usernames!(tmp_username)
      expect(username).not_to eq tmp_username
      expect(described_class.all.pluck(:username)).not_to include username
    end
  end

  describe 'commented_recipes' do
    context 'when user creates comments on the same recipe more than once' do
      it 'returns uniq recipes' do
        alice = create(:user)
        recipe = create(:recipe)
        create_list(:comment, 2, recipe: recipe, user: alice)
        create_list(:comment, 2, user: alice)
        expect(alice.commented_recipes.size).to eq 3
      end
    end
  end
end
