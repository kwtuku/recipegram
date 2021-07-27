require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:alice) { create :user, :no_image }
  let(:alice_recipe) { create :recipe, :no_image, user: alice }
  let(:bob) { create :user, :no_image }

  describe 'comments#create' do
    it 'increases Notification count' do
      sign_in bob
      comment_params = attributes_for(:comment)
      expect {
        post recipe_comments_path(alice_recipe), params: { comment: comment_params }
      }.to change { Notification.count }.by(1)
    end

    it 'increases User.notifications count' do
      sign_in bob
      comment_params = attributes_for(:comment)
      expect {
        post recipe_comments_path(alice_recipe), params: { comment: comment_params }
      }.to change { alice.notifications.count }.by(1)
    end
  end

  describe 'favorites#create' do
    it 'increases Notification count' do
      sign_in bob
      expect {
        post recipe_favorites_path(alice_recipe), xhr: true
      }.to change { Notification.count }.by(1)
    end

    it 'increases User.notifications count' do
      sign_in bob
      expect {
        post recipe_favorites_path(alice_recipe), xhr: true
      }.to change { alice.notifications.count }.by(1)
    end
  end

  describe 'relationships#create' do
    it 'increases Notification count' do
      sign_in alice
      expect {
        post relationships_path, params: { follow_id: bob.id }, xhr: true
      }.to change { Notification.count }.by(1)
    end

    it 'increases User.notifications count' do
      sign_in alice
      expect {
        post relationships_path, params: { follow_id: bob.id }, xhr: true
      }.to change { bob.notifications.count }.by(1)
    end
  end
end
