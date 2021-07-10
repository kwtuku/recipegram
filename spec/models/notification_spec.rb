require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:alice) { create :user }
  let(:bob) { create :user }

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
