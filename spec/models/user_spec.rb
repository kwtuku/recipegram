require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:nickname) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    describe 'username' do
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_length_of(:username).is_at_most(15) }

      it 'excludes reserved words' do
        RESERVED_WORDS = %w[
          sign_in
          sign_out
          password
          cancel
          sign_up
          edit
          guest_sign_in
        ].freeze
        expect(subject).to validate_exclusion_of(:username).in_array(RESERVED_WORDS)
      end

      it 'is invalid with invalid formats' do
        INVALID_USERNAMES = %W[
          i_am_alice!
          i_am_alice.
          i/am/alice
          1_am_alice.
          ありす
          アリス
          愛凜翠
          #{'i am alice'}
          #{' alice'}
          #{'alice '}
        ].freeze
        alice = build(:user, :no_image)
        INVALID_USERNAMES.each do |invalid_username|
          alice.username = invalid_username
          expect(alice.invalid?).to eq true
        end
      end

      it 'is valid with valid formats' do
        VALID_USERNAMES = %w[
          i_am_alice
          1_am_alice
          i-am-alice
          a1-_B2
          aaa
          AAA
          111
          ---
          ___
          -_-
        ].freeze
        alice = build(:user, :no_image)
        VALID_USERNAMES.each do |valid_username|
          alice.username = valid_username
          expect(alice.valid?).to eq true
        end
      end

      it 'is saved as lower-case' do
        alice = create(:user, :no_image, username: 'ALICE')
        expect(alice.username).to eq 'alice'
        alice.username = 'I_aM-AliCe'
        alice.save
        expect(alice.username).to eq 'i_am-alice'
      end

      it 'does not recognize if a letter is a capital or a small letter' do
        alice = create(:user, :no_image, username: 'alice')
        bob = build(:user, :no_image, username: 'ALICE')
        expect(bob.invalid?).to eq true
      end

      it 'is invalid when username is already taken' do
        alice = create(:user, :no_image, username: 'alice')
        bob = build(:user, :no_image, username: 'alice')
        expect(bob.invalid?).to eq true
      end
    end
  end

  describe 'already_favored?(recipe)' do
    let(:alice) { create(:user, :no_image) }
    let(:favored_recipe) { create(:recipe, :no_image) }
    let!(:not_favored_recipe) { create(:recipe, :no_image) }

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
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }

    it 'increases relationship count' do
      expect do
        alice.follow(bob)
      end.to change(Relationship, :count).by(1)
        .and change(alice.followings, :count).by(1)
        .and change(bob.followers, :count).by(1)
    end
  end

  describe 'unfollow(other_user)' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }

    before { alice.relationships.create!(follow_id: bob.id) }

    it 'decreases relationship count' do
      expect do
        alice.unfollow(bob)
      end.to change(Relationship, :count).by(-1)
        .and change(alice.followings, :count).by(-1)
        .and change(bob.followers, :count).by(-1)
    end
  end

  describe 'following?(other_user)' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:carol) { create(:user, :no_image) }

    before { alice.relationships.create!(follow_id: bob.id) }

    context 'when alice follows a user' do
      it 'returns true' do
        expect(alice.following?(bob)).to eq true
      end
    end

    context 'when alice does not follow a user' do
      it 'returns false' do
        expect(alice.following?(carol)).to eq false
      end
    end
  end

  describe 'followers_you_follow(you)' do
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
      expect(bob.followers_you_follow(alice)).not_to include ellen, frank
    end
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
      carol.recipes.each do |recipe_unfollowing|
        expect(alice.feed.include?(recipe_unfollowing)).to eq false
      end
    end
  end

  describe 'home_recipes' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:carol) { create(:user, :no_image) }
    let(:dave) { create(:user, :no_image) }
    let(:ellen) { create(:user, :no_image) }

    context 'when feed is present' do
      before do
        [alice, bob, carol, dave, ellen].each do |user|
          create_list :recipe, 3, :no_image, user: user, updated_at: rand(1..100).minutes.ago
        end
        alice.relationships.create!(follow_id: bob.id)
        alice.relationships.create!(follow_id: dave.id)
      end

      it 'has feed at the beginning' do
        feed_count = alice.feed.size
        alice.feed.each do |feed|
          expect(alice.home_recipes[0..(feed_count - 1)].include?(feed)).to eq true
        end
      end

      it 'does not have unfollowing user recipes at the beginning' do
        feed_count = alice.feed.size
        carol.recipes.each do |carol_recipe|
          expect(alice.home_recipes[0..(feed_count - 1)].include?(carol_recipe)).to eq false
        end
        ellen.recipes.each do |ellen_recipe|
          expect(alice.home_recipes[0..(feed_count - 1)].include?(ellen_recipe)).to eq false
        end
      end

      it 'does not have feed after feed' do
        feed_count = alice.feed.size
        alice.feed.each do |feed|
          expect(alice.home_recipes[feed_count..].include?(feed)).to eq false
        end
      end

      it 'has unfollowing user recipes after feed' do
        feed_count = alice.feed.size
        carol.recipes.each do |carol_recipe|
          expect(alice.home_recipes[feed_count..].include?(carol_recipe)).to eq true
        end
        ellen.recipes.each do |ellen_recipe|
          expect(alice.home_recipes[feed_count..].include?(ellen_recipe)).to eq true
        end
      end
    end

    context 'when feed is blank' do
      before do
        [bob, carol, dave, ellen].each do |user|
          create_list :recipe, 3, :no_image, user: user, updated_at: rand(1..100).minutes.ago
        end
      end

      it 'has unfollowing user recipes' do
        expect(alice.feed.count).to eq 0
        [bob, carol, dave, ellen].each do |user|
          user.recipes.each do |unfollowing_user_recipe|
            expect(alice.home_recipes.include?(unfollowing_user_recipe)).to eq true
          end
        end
      end
    end
  end

  describe 'self.guest' do
    context 'when guest exists' do
      let!(:guest) { create :user, email: 'guest@example.com' }

      it 'is valid' do
        expect(described_class.guest.valid?).to eq true
      end

      it 'does not increase user count' do
        expect do
          described_class.guest
        end.to change(described_class, :count).by(0)
      end
    end

    context 'when guest dose not exist' do
      it 'is valid' do
        expect(described_class.guest.valid?).to eq true
      end

      it 'increases user count' do
        expect do
          described_class.guest
        end.to change(described_class, :count).by(1)
      end
    end
  end

  describe 'self.generate_username' do
    before do
      create_list :user, 10, :no_image
    end

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
    before do
      create_list :user, 10, :no_image
    end

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
end
