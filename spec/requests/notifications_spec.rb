require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:alice) { create(:user, :no_image) }
  let(:alice_recipe) { create(:recipe, :no_image, user: alice) }
  let(:bob) { create(:user, :no_image) }
  let(:comment_params) { attributes_for(:comment) }

  describe '#index' do
    before do
      sign_in bob
      post recipe_comments_path(alice_recipe), params: { comment: comment_params }
      post relationships_path, params: { follow_id: alice.id }, xhr: true
      post recipe_favorites_path(alice_recipe), xhr: true
      sign_out bob
    end

    context 'when not signed in' do
      it 'returns found' do
        get notifications_path
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get notifications_path
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not change read attribute from false to true' do
        expect do
          get notifications_path
        end.not_to change { alice.notifications.sample.reload.read }.from(false)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        get notifications_path
        expect(response).to have_http_status(:ok)
      end

      it 'renders notifications' do
        get notifications_path
        expect(response.body).to include bob.nickname
        expect(response.body).to include "あなたの投稿「#{alice_recipe.title}」"
        expect(response.body).to include 'にコメントしました。'
        expect(response.body).to include 'にいいねしました。'
        expect(response.body).to include 'あなたをフォローしました。'
      end

      it 'changes read attribute from false to true' do
        expect do
          get notifications_path
        end.to change { alice.notifications.sample.reload.read }.from(false).to(true)
      end
    end
  end

  describe 'comments#create' do
    context 'when a comment is saved' do
      it 'increases recipe user notification count' do
        sign_in bob
        expect do
          post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        end.to change(alice.notifications, :count).by(1)
      end
    end

    context 'when a comment is not saved' do
      it 'does not increase Notification count' do
        invalid_comment_params = { body: '' }
        sign_in bob
        expect do
          post recipe_comments_path(alice_recipe), params: { comment: invalid_comment_params }
        end.to change(Notification, :count).by(0)
      end
    end

    context 'when other user comments on commented recipe' do
      it 'increases recipe user notification count and other comment user notification count' do
        carol = create(:user, :no_image)
        bob_recipe = create(:recipe, :no_image, user: bob)
        create(:comment, recipe: bob_recipe, user: alice)
        sign_in carol
        expect do
          post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        end.to change(alice.notifications, :count).by(1).and change(bob.notifications, :count).by(1)
      end
    end

    context 'when user comments on own recipe' do
      it 'does not increase Notification count' do
        sign_in alice
        expect do
          post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        end.to change(Notification, :count).by(0)
      end
    end

    context 'when other user comments on the recipe which user owns and commented' do
      it 'increases recipe user notification count by 1' do
        create(:comment, recipe: alice_recipe, user: alice)
        sign_in bob
        expect do
          post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        end.to change(alice.notifications, :count).by(1)
      end
    end
  end

  describe 'favorites#create' do
    context 'when user makes a favorite on other user recipe' do
      it 'increases recipe user notification count' do
        sign_in bob
        expect do
          post recipe_favorites_path(alice_recipe), xhr: true
        end.to change(alice.notifications, :count).by(1)
      end
    end

    context 'when user makes a favorite on own recipe' do
      it 'does not increase Notification count' do
        sign_in alice
        expect do
          post recipe_favorites_path(alice_recipe), xhr: true
        end.to change(Notification, :count).by(0)
      end
    end
  end

  describe 'relationships#create' do
    it 'increases followed user notification count' do
      sign_in bob
      expect do
        post relationships_path, params: { follow_id: alice.id }, xhr: true
      end.to change(alice.notifications, :count).by(1)
    end
  end
end
