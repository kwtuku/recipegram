require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    before { create_list(:user, 5, :no_image) }

    let(:alice) { create(:user, :no_image) }

    it 'returns ok when not signed in' do
      get users_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns ok when signed in' do
      sign_in alice
      get users_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:username' do
    let(:alice) { create(:user, :no_image) }

    it 'returns ok when not signed in' do
      get user_path(alice)
      expect(response).to have_http_status(:ok)
    end

    it 'returns ok when signed in' do
      sign_in alice
      get user_path(alice)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/edit/profile' do
    let(:alice) { create(:user, :no_image) }

    context 'when not signed in' do
      it 'returns found' do
        get edit_users_path
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get edit_users_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      it 'returns ok' do
        sign_in alice
        get edit_users_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH /users/:username' do
    let(:alice) { create(:user, :no_image, nickname: 'アリス', profile: 'アリスです。') }
    let(:bob) { create(:user, :no_image, nickname: 'ボブ', profile: 'ボブだよ。') }
    let(:user_params) do
      new_user_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user_image_sample_after.jpg'))
      { nickname: 'ありす', profile: 'ありすです。', user_image: new_user_image }
    end

    context 'when not signed in' do
      it 'returns found' do
        patch user_path(alice), params: { user: user_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        patch user_path(alice), params: { user: user_params }
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not update user' do
        patch user_path(alice), params: { user: user_params }
        expect(alice.reload.nickname).to eq 'アリス'
        expect(alice.reload.profile).to eq 'アリスです。'
      end
    end

    context 'when signed in as wrong user' do
      before { sign_in bob }

      it 'returns found' do
        patch user_path(alice), params: { user: user_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to user_path(wrong user)' do
        patch user_path(alice), params: { user: user_params }
        expect(response).to redirect_to user_path(bob)
      end

      it 'does not update user' do
        patch user_path(alice), params: { user: user_params }
        expect(alice.reload.nickname).to eq 'アリス'
        expect(alice.reload.profile).to eq 'アリスです。'
      end
    end

    context 'when signed in as correct user' do
      before { sign_in alice }

      it 'returns found' do
        patch user_path(alice), params: { user: user_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to user_path(correct user)' do
        patch user_path(alice), params: { user: user_params }
        expect(response).to redirect_to user_path(alice)
      end

      it 'updates a nickname and a profile' do
        patch user_path(alice), params: { user: user_params }
        expect(alice.reload.nickname).to eq 'ありす'
        expect(alice.reload.profile).to eq 'ありすです。'
      end

      it 'updates a user_image' do
        old_image_url = alice.user_image_url
        patch user_path(alice), params: { user: user_params }
        expect(alice.reload.user_image_url).not_to eq old_image_url
      end
    end
  end

  describe 'GET /users/:user_username/followings' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:carol) { create(:user, :no_image) }

    before do
      alice.relationships.create(follow_id: bob.id)
      alice.relationships.create(follow_id: carol.id)
    end

    context 'when not signed in' do
      it 'returns found' do
        get user_followings_path(alice)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get user_followings_path(alice)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        get user_followings_path(alice)
        expect(response).to have_http_status(:ok)
      end

      it 'renders following links' do
        get user_followings_path(alice)
        expect(response.body).to include "/users/#{bob.username}", "/users/#{carol.username}"
      end
    end
  end

  describe 'GET /users/:user_username/followers' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:carol) { create(:user, :no_image) }

    before do
      bob.relationships.create(follow_id: alice.id)
      carol.relationships.create(follow_id: alice.id)
    end

    context 'when not signed in' do
      it 'returns found' do
        get user_followers_path(alice)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get user_followers_path(alice)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      before { sign_in bob }

      it 'returns ok' do
        get user_followers_path(alice)
        expect(response).to have_http_status(:ok)
      end

      it 'renders follower links' do
        get user_followers_path(alice)
        expect(response.body).to include "/users/#{bob.username}", "/users/#{carol.username}"
      end
    end
  end

  describe 'GET /users/:user_username/comments' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:carol) { create(:user, :no_image) }
    let(:bob_recipe) { create(:recipe, :no_image, user: bob) }
    let(:carol_recipe) { create(:recipe, :no_image, user: carol) }

    before do
      create(:comment, user: alice, recipe: bob_recipe)
      create(:comment, user: alice, recipe: carol_recipe)
    end

    context 'when not signed in' do
      it 'returns found' do
        get user_comments_path(alice)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get user_comments_path(alice)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      before { sign_in bob }

      it 'returns ok' do
        get user_comments_path(alice)
        expect(response).to have_http_status(:ok)
      end

      it 'renders commented recipe links' do
        get user_comments_path(alice)
        expect(response.body).to include "/recipes/#{bob_recipe.id}", "/recipes/#{carol_recipe.id}"
      end
    end
  end

  describe 'GET /users/:user_username/favorites' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:carol) { create(:user, :no_image) }
    let(:bob_recipe) { create(:recipe, :no_image, user: bob) }
    let(:carol_recipe) { create(:recipe, :no_image, user: carol) }

    before do
      alice.favorites.create(recipe_id: bob_recipe.id)
      alice.favorites.create(recipe_id: carol_recipe.id)
    end

    context 'when not signed in' do
      it 'returns found' do
        get user_favorites_path(alice)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get user_favorites_path(alice)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      before { sign_in bob }

      it 'returns ok' do
        get user_favorites_path(alice)
        expect(response).to have_http_status(:ok)
      end

      it 'renders favored recipe links' do
        get user_favorites_path(alice)
        expect(response.body).to include "/recipes/#{bob_recipe.id}", "/recipes/#{carol_recipe.id}"
      end
    end
  end

  describe 'GET /generate_username' do
    it 'returns ok' do
      get generate_username_path, xhr: true
      expect(response).to have_http_status(:ok)
    end
  end
end
