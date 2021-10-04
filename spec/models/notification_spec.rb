require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:alice) { create :user, :no_image }
  let(:bob) { create :user, :no_image }

  describe 'comment notification' do
    let(:alice_recipe) { create :recipe, :no_image, user: alice }
    let!(:bob_comment) { create :comment, user: bob, recipe: alice_recipe }
    let(:carol) { create :user, :no_image }
    let!(:carol_comment) { create :comment, user: carol, recipe: alice_recipe }

    context 'when comment user != recipe user' do
      let(:dave) { create :user, :no_image }
      let(:dave_comment) { create :comment, user: dave, recipe: alice_recipe }

      it 'creates comment notification for recipe user' do
        expect do
          described_class.create_comment_notification(dave_comment)
        end.to change(described_class, :count).by(3)
          .and change(alice.notifications, :count).by(1)
      end

      it 'creates comment notification for other comment user' do
        expect do
          described_class.create_comment_notification(dave_comment)
        end.to change(described_class, :count).by(3)
          .and change(bob.notifications, :count).by(1)
          .and change(carol.notifications, :count).by(1)
      end

      it 'does not create comment notification for comment user' do
        expect do
          described_class.create_comment_notification(dave_comment)
        end.to change(described_class, :count).by(3)
          .and change(dave.notifications, :count).by(0)
      end
    end

    context 'when comment user == recipe user' do
      let(:alice_comment) { create :comment, user: alice, recipe: alice_recipe }

      it 'does not create comment notification for recipe user' do
        expect do
          described_class.create_comment_notification(alice_comment)
        end.to change(described_class, :count).by(2)
          .and change(alice.notifications, :count).by(0)
      end

      it 'creates comment notification for other comment user' do
        expect do
          described_class.create_comment_notification(alice_comment)
        end.to change(described_class, :count).by(2)
          .and change(bob.notifications, :count).by(1)
          .and change(carol.notifications, :count).by(1)
      end
    end
  end

  describe 'self.comment_notification_receiver_ids(comment)' do
    let(:alice_recipe) { create :recipe, :no_image, user: alice }
    let!(:bob_comment) { create :comment, user: bob, recipe: alice_recipe }
    let(:carol) { create :user, :no_image }
    let!(:carol_comment) { create :comment, user: carol, recipe: alice_recipe }

    context 'when comment user != recipe user' do
      let(:dave) { create :user, :no_image }
      let(:dave_comment) { create :comment, user: dave, recipe: alice_recipe }

      it 'has recipe user id' do
        expect(described_class.comment_notification_receiver_ids(dave_comment)).to include alice.id
      end

      it 'has other comment user id' do
        expect(described_class.comment_notification_receiver_ids(dave_comment)).to include bob.id, carol.id
      end

      it 'does not have comment user id' do
        expect(described_class.comment_notification_receiver_ids(dave_comment)).not_to include dave.id
      end
    end

    context 'when comment user == recipe user' do
      let(:alice_comment) { create :comment, user: alice, recipe: alice_recipe }

      it 'does not have recipe user id' do
        expect(described_class.comment_notification_receiver_ids(alice_comment)).not_to include alice.id
      end

      it 'has other comment user id' do
        expect(described_class.comment_notification_receiver_ids(alice_comment)).to include bob.id, carol.id
      end
    end
  end

  describe 'self.create_favorite_notification(favorite)' do
    let(:alice_recipe) { create :recipe, :no_image, user: alice }

    it 'creates favorite notification when user makes a favorite on the recipe other user created' do
      favorite = bob.favorites.create(recipe_id: alice_recipe.id)
      expect do
        described_class.create_favorite_notification(favorite)
      end.to change(described_class, :count).by(1)
        .and change(alice.notifications, :count).by(1)
    end

    it 'does not create favorite notification when user makes a favorite on own recipe' do
      favorite = alice.favorites.create(recipe_id: alice_recipe.id)
      expect do
        described_class.create_favorite_notification(favorite)
      end.to change(described_class, :count).by(0)
        .and change(alice.notifications, :count).by(0)
    end
  end

  describe 'self.create_relationship_notification(relationship)' do
    it 'creates relationship notification' do
      relationship = bob.follow(alice)
      expect do
        described_class.create_relationship_notification(relationship)
      end.to change(described_class, :count).by(1)
        .and change(alice.notifications, :count).by(1)
    end
  end
end
