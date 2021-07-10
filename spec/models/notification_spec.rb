require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:alice) { create :user }
  let(:bob) { create :user }

  describe 'comment notification' do
    let(:alice_recipe) { create :recipe, user: alice }
    let!(:bob_comment) { create :comment, user: bob, recipe: alice_recipe }
    let(:carol) { create :user }
    let!(:carol_comment) { create :comment, user: carol, recipe: alice_recipe }

    context 'comment user != recipe user' do
      let(:dave) { create :user }
      let(:dave_comment) { create :comment, user: dave, recipe: alice_recipe }

      it 'creates comment notification for recipe user' do
        expect{
          Notification.create_comment_notification(dave_comment)
        }.to change { alice.notifications.count }.by(1)
      end

      it 'creates comment notification for other comment user' do
        expect{
          Notification.create_comment_notification(dave_comment)
        }.to change { bob.notifications.count }.by(1)
        .and change { carol.notifications.count }.by(1)
      end

      it 'does not create comment notification for comment user' do
        expect{
          Notification.create_comment_notification(dave_comment)
        }.to change { dave.notifications.count }.by(0)
      end
    end

    context 'comment user == recipe user' do
      let(:alice_comment) { create :comment, user: alice, recipe: alice_recipe }

      it 'does not create comment notification for recipe user' do
        expect{
          Notification.create_comment_notification(alice_comment)
        }.to change { alice.notifications.count }.by(0)
      end

      it 'creates comment notification for other comment user' do
        expect{
          Notification.create_comment_notification(alice_comment)
        }.to change { bob.notifications.count }.by(1)
        .and change { carol.notifications.count }.by(1)
      end
    end
  end

  describe 'self.comment_notification_receiver_ids(comment)' do
    let(:alice_recipe) { create :recipe, user: alice }
    let!(:bob_comment) { create :comment, user: bob, recipe: alice_recipe }
    let(:carol) { create :user }
    let!(:carol_comment) { create :comment, user: carol, recipe: alice_recipe }

    context 'comment user != recipe user' do
      let(:dave) { create :user }
      let(:dave_comment) { create :comment, user: dave, recipe: alice_recipe }

      it 'has recipe user id' do
        expect(Notification.comment_notification_receiver_ids(dave_comment)).to include alice.id
      end

      it 'has other comment user id' do
        expect(Notification.comment_notification_receiver_ids(dave_comment)).to include bob.id, carol.id
      end

      it 'does not have comment user id' do
        expect(Notification.comment_notification_receiver_ids(dave_comment)).to_not include dave.id
      end
    end

    context 'comment user == recipe user' do
      let(:alice_comment) { create :comment, user: alice, recipe: alice_recipe }

      it 'does not have recipe user id' do
        expect(Notification.comment_notification_receiver_ids(alice_comment)).to_not include alice.id
      end

      it 'has other comment user id' do
        expect(Notification.comment_notification_receiver_ids(alice_comment)).to include bob.id, carol.id
      end
    end
  end

  describe 'self.create_favorite_notification(favorite)' do
    let(:alice_recipe) { create :recipe, user: alice }

    it 'creates favorite notification when user makes a favorite on the recipe other user created' do
      favorite = bob.favorites.create(recipe_id: alice_recipe.id)
      expect{
        Notification.create_favorite_notification(favorite)
      }.to change { alice.notifications.count }.by(1)
    end

    it 'does not create favorite notification when user makes a favorite on own recipe' do
      favorite = alice.favorites.create(recipe_id: alice_recipe.id)
      expect{
        Notification.create_favorite_notification(favorite)
      }.to change { alice.notifications.count }.by(0)
    end
  end

  describe 'self.create_relationship_notification(relationship)' do
    it 'creates relationship notification' do
      relationship = bob.follow(alice)
      expect{
        Notification.create_relationship_notification(relationship)
      }.to change { alice.notifications.count }.by(1)
    end
  end
end
