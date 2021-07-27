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
        RESERVED_WORDS = %w(
          sign_in
          sign_out
          password
          cancel
          sign_up
          edit
          guest_sign_in
        )
        is_expected.to validate_exclusion_of(:username).in_array(RESERVED_WORDS)
      end

      it "is invalid with invalid formats" do
        INVALID_USERNAMES = %W(
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
        )
        alice = build(:user, :no_image)
        INVALID_USERNAMES.each do |invalid_username|
          alice.username = invalid_username
          expect(alice.invalid?).to eq true
        end
      end

      it "is valid with valid formats" do
        VALID_USERNAMES = %w(
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
        )
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

  describe 'self.guest' do
    it 'is valid' do
      guest = User.guest
      expect(guest.valid?).to eq true
    end

    it 'exists guest user' do
      User.guest
      expect(User.exists?(email: 'guest@example.com')).to eq true
    end
  end

  describe 'self.generate_username' do
    let!(:alice) { create :user, :no_image, username: 'alice' }

    it 'generates username different from existing usernames' do
      username = User.generate_username
      expect(User.all.pluck(:username)).to_not include username
    end
  end

  describe 'self.vary_from_usernames!(tmp_username)' do
    let!(:alice) { create :user, :no_image, username: 'alice' }

    it 'makes tmp_username different from existing usernames' do
      tmp_username = 'alice'
      username = User.vary_from_usernames!(tmp_username)
      expect(username).to_not eq 'alice'
      expect(User.all.pluck(:username)).to_not include username
    end
  end
end
