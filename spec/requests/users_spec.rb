require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#index' do
    let(:alice) { create :user }

    it 'returns a 200 response when not signed in' do
      get users_path
      expect(response).to have_http_status(200)
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get users_path
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    let(:alice) { create :user }

    it 'returns a 200 response when not signed in' do
      get user_path(alice)
      expect(response).to have_http_status(200)
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get user_path(alice)
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    let(:alice) { create :user }

    it 'redirects to new_user_session_path when not signed in' do
      get edit_users_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get edit_users_path
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    let(:alice) { create :user, nickname: 'アリス', profile: 'アリスです。' }
    let(:bob) { create :user, nickname: 'ボブ', profile: 'ボブだよ。' }

    context 'when not signed in' do
      it 'does not update user' do
        user_params = { nickname: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(alice.reload.nickname).to eq 'アリス'
        expect(alice.reload.profile).to eq 'アリスです。'
      end

      it 'redirects to new_user_session_path' do
        user_params = { nickname: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in as wrong user' do
      it 'does not update user' do
        sign_in bob
        user_params = { nickname: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(alice.reload.nickname).to eq 'アリス'
        expect(alice.reload.profile).to eq 'アリスです。'
      end

      it 'redirects to user_path(wrong user)' do
        sign_in bob
        user_params = { nickname: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(response).to redirect_to user_path(bob)
      end
    end

    context 'when signed in as correct user' do
      it 'updates user' do
        sign_in alice
        user_params = { nickname: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(alice.reload.nickname).to eq 'ありす'
        expect(alice.reload.profile).to eq 'ありすです。'
      end

      it 'redirects to user_path(correct user)' do
        sign_in alice
        user_params = { nickname: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(response).to redirect_to user_path(alice)
      end
    end
  end

  describe '#followings' do
    let(:alice) { create :user, nickname: 'alice' }
    let!(:bob) { create :user, nickname: 'bob' }
    let!(:carol) { create :user, nickname: 'carol' }
    before do
      alice.relationships.create(follow_id: bob.id)
      alice.relationships.create(follow_id: carol.id)
    end

    context 'when not signed in' do
      it 'redirects to new_user_session_path when not signed in' do
        get user_followings_path(alice)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      it 'returns a 200 response when signed in' do
        sign_in alice
        get user_followings_path(alice)
        expect(response).to have_http_status(200)
      end

      it 'renders following nicknames when signed in' do
        sign_in alice
        get user_followings_path(alice)
        expect(response.body).to include 'bob', 'carol'
      end
    end
  end

  describe '#followers' do
    let!(:alice) { create :user, nickname: 'alice' }
    let(:bob) { create :user, nickname: 'bob' }
    let(:carol) { create :user, nickname: 'carol' }
    before do
      bob.relationships.create(follow_id: alice.id)
      carol.relationships.create(follow_id: alice.id)
    end

    context 'when not signed in' do
      it 'redirects to new_user_session_path when not signed in' do
        get user_followers_path(alice)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      it 'returns a 200 response when signed in' do
        sign_in bob
        get user_followers_path(alice)
        expect(response).to have_http_status(200)
      end

      it 'renders follower nicknames when signed in' do
        sign_in bob
        get user_followers_path(alice)
        expect(response.body).to include 'bob', 'carol'
      end
    end
  end

  describe '#comments' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:carol) { create :user }
    let(:bob_recipe) { create :recipe, user: bob }
    let(:carol_recipe) { create :recipe, user: carol }
    let!(:alice_comment_on_bob_recipe) { create :comment, user: alice, recipe: bob_recipe }
    let!(:alice_comment_on_carol_recipe) { create :comment, user: alice, recipe: carol_recipe }

    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        get user_comments_path(alice)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      it 'returns a 200 response' do
        sign_in bob
        get user_comments_path(alice)
        expect(response).to have_http_status(200)
      end

      it 'renders commented recipe links' do
        sign_in bob
        get user_comments_path(alice)
        expect(response.body).to include "/recipes/#{bob_recipe.id}", "/recipes/#{carol_recipe.id}"
      end
    end
  end

  describe '#favorites' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:carol) { create :user }
    let(:bob_recipe) { create :recipe, user: bob }
    let(:carol_recipe) { create :recipe, user: carol }
    before do
      alice.favorites.create(recipe_id: bob_recipe.id)
      alice.favorites.create(recipe_id: carol_recipe.id)
    end

    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        get user_favorites_path(alice)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      it 'returns a 200 response' do
        sign_in bob
        get user_favorites_path(alice)
        expect(response).to have_http_status(200)
      end

      it 'renders favored recipe links' do
        sign_in bob
        get user_favorites_path(alice)
        expect(response.body).to include "/recipes/#{bob_recipe.id}", "/recipes/#{carol_recipe.id}"
      end
    end
  end
end
