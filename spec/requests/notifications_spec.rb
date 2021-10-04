require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:alice) { create :user, :no_image }
  let(:alice_recipe) { create :recipe, :no_image, user: alice }
  let(:bob) { create :user, :no_image }

  describe 'comments#create' do
    before { sign_in bob }

    let(:comment_params) { attributes_for(:comment) }

    context 'when a comment is saved' do
      it 'increases Notification count' do
        expect do
          post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        end.to change(Notification, :count).by(1)
          .and change(alice.notifications, :count).by(1)
      end
    end

    context 'when a comment is not saved' do
      it 'does not increase Notification count' do
        invalid_comment_params = { body: '' }
        expect do
          post recipe_comments_path(alice_recipe), params: { comment: invalid_comment_params }
        end.to change(Notification, :count).by(0)
          .and change(alice.notifications, :count).by(0)
      end
    end
  end

  describe 'favorites#create' do
    it 'increases Notification count' do
      sign_in bob
      expect do
        post recipe_favorites_path(alice_recipe), xhr: true
      end.to change(Notification, :count).by(1)
        .and change(alice.notifications, :count).by(1)
    end
  end

  describe 'relationships#create' do
    it 'increases Notification count' do
      sign_in bob
      expect do
        post relationships_path, params: { follow_id: alice.id }, xhr: true
      end.to change(Notification, :count).by(1)
        .and change(alice.notifications, :count).by(1)
    end
  end
end
