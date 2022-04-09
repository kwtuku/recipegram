require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:alice) { create(:user) }
  let(:bob) { create(:user) }

  describe 'self.create_comment_notification(comment)' do
    let(:alice_recipe) { create(:recipe, user: alice) }

    context 'when other user comments' do
      it 'increases recipe user notification count' do
        bob_comment = create(:comment, user: bob, recipe: alice_recipe)
        expect do
          described_class.create_comment_notification(bob_comment)
        end.to change(alice.notifications, :count).by(1)
      end
    end

    context 'when other user comments on commented recipe' do
      let(:carol) { create(:user) }
      let(:carol_comment) { create(:comment, user: carol, recipe: alice_recipe) }

      before { create(:comment, user: bob, recipe: alice_recipe) }

      it 'increases recipe user notification count' do
        expect do
          described_class.create_comment_notification(carol_comment)
        end.to change(alice.notifications, :count).by(1)
      end

      it 'increases other commented user notification count' do
        expect do
          described_class.create_comment_notification(carol_comment)
        end.to change(bob.notifications, :count).by(1)
      end
    end

    context 'when other user comments on the recipe which user owns and commented' do
      it 'increases recipe user notification count by 1' do
        create(:comment, user: alice, recipe: alice_recipe)
        bob_comment = create(:comment, user: bob, recipe: alice_recipe)
        expect do
          described_class.create_comment_notification(bob_comment)
        end.to change(alice.notifications, :count).by(1)
      end
    end

    context 'when user comments on own recipe' do
      it 'does not increase Notification count' do
        alice_comment = create(:comment, user: alice, recipe: alice_recipe)
        expect do
          described_class.create_comment_notification(alice_comment)
        end.to change(described_class, :count).by(0)
      end
    end
  end

  describe 'self.comment_notification_receiver_ids(comment)' do
    let(:alice_recipe) { create(:recipe, user: alice) }

    it 'returns uniq ids including recipe user id' do
      create(:comment, user: alice, recipe: alice_recipe)
      create_list(:comment, 2, user: bob, recipe: alice_recipe)
      carol = create(:user)
      carol_comment = create(:comment, user: carol, recipe: alice_recipe)
      receiver_ids = described_class.comment_notification_receiver_ids(carol_comment)
      expect(receiver_ids.size).to eq receiver_ids.uniq.size
    end

    it 'returns uniq ids not including recipe user id' do
      create_list(:comment, 2, user: bob, recipe: alice_recipe)
      carol = create(:user)
      carol_comment = create(:comment, user: carol, recipe: alice_recipe)
      receiver_ids = described_class.comment_notification_receiver_ids(carol_comment)
      expect(receiver_ids.size).to eq receiver_ids.uniq.size
    end

    context 'when other user comments' do
      let(:bob_comment) { create(:comment, user: bob, recipe: alice_recipe) }

      it 'has recipe user id' do
        expect(described_class.comment_notification_receiver_ids(bob_comment)).to include alice.id
      end

      it 'does not have comment user id' do
        expect(described_class.comment_notification_receiver_ids(bob_comment)).not_to include bob.id
      end
    end

    context 'when other user comments on commented recipe' do
      let(:carol) { create(:user) }
      let(:carol_comment) { create(:comment, user: carol, recipe: alice_recipe) }

      before { create(:comment, user: bob, recipe: alice_recipe) }

      it 'has recipe user id' do
        expect(described_class.comment_notification_receiver_ids(carol_comment)).to include alice.id
      end

      it 'has other comment user id' do
        expect(described_class.comment_notification_receiver_ids(carol_comment)).to include bob.id
      end

      it 'does not have comment user id' do
        expect(described_class.comment_notification_receiver_ids(carol_comment)).not_to include carol.id
      end
    end

    context 'when other user comments on the recipe which user owns and commented' do
      let(:bob_comment) { create(:comment, user: bob, recipe: alice_recipe) }

      before { create(:comment, user: alice, recipe: alice_recipe) }

      it 'has recipe user id' do
        expect(described_class.comment_notification_receiver_ids(bob_comment)).to include alice.id
      end

      it 'does not have comment user id' do
        expect(described_class.comment_notification_receiver_ids(bob_comment)).not_to include bob.id
      end
    end

    context 'when user comments on own recipe' do
      let(:alice_comment) { create(:comment, user: alice, recipe: alice_recipe) }

      it 'does not have recipe user id and comment user id' do
        expect(described_class.comment_notification_receiver_ids(alice_comment)).not_to include alice.id
      end
    end
  end

  describe 'self.create_favorite_notification(favorite)' do
    let(:alice_recipe) { create(:recipe, user: alice) }

    context 'when other user makes a favorite' do
      it 'increases recipe user notification count' do
        favorite = bob.favorites.create(recipe_id: alice_recipe.id)
        expect do
          described_class.create_favorite_notification(favorite)
        end.to change(alice.notifications, :count).by(1)
      end
    end

    context 'when user makes a favorite on own recipe' do
      it 'does not increase Notification count' do
        favorite = alice.favorites.create(recipe_id: alice_recipe.id)
        expect do
          described_class.create_favorite_notification(favorite)
        end.to change(described_class, :count).by(0)
      end
    end
  end

  describe 'self.create_relationship_notification(relationship)' do
    it 'increases followed user notification count' do
      relationship = bob.relationships.create(follow_id: alice.id)
      expect do
        described_class.create_relationship_notification(relationship)
      end.to change(alice.notifications, :count).by(1)
    end
  end
end
