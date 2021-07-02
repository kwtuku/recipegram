require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'public pages' do
    let(:alice) { create :user }

    it 'users#index returns a 200 response' do
      get users_path
      expect(response).to have_http_status(200)
    end

    it 'users#show returns a 200 response' do
      get user_path(alice)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/:id/edit' do
    let(:alice) { create :user }
    let(:bob) { create :user }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        get edit_user_path(alice)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in as wrong user' do
      it 'redirect_to user_path(user)' do
        sign_in bob
        get edit_user_path(alice)
        expect(response).to redirect_to user_path(alice)
      end
    end

    context 'signed in as correct user' do
      it 'returns a 200 response' do
        sign_in alice
        get edit_user_path(alice)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH /users/:id' do
    let(:alice) { create :user, username: 'アリス', profile: 'アリスです。' }
    let(:bob) { create :user, username: 'ボブ', profile: 'ボブだよ。' }

    context 'not signed in' do
      it 'redirect_to new_user_registration_path' do
        user_params = { username: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
        expect(alice.reload.username).to eq 'アリス'
        expect(alice.reload.profile).to eq 'アリスです。'
      end
    end

    context 'signed in as wrong user' do
      it 'can not update user' do
        sign_in bob
        user_params = { username: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(response).to redirect_to user_path(alice)
        expect(alice.reload.username).to eq 'アリス'
        expect(alice.reload.profile).to eq 'アリスです。'
      end
    end

    context 'signed in as correct user' do
      it 'update user' do
        sign_in alice
        user_params = { username: 'ありす', profile: 'ありすです。' }
        patch user_path(alice), params: { user: user_params }
        expect(alice.reload.username).to eq 'ありす'
        expect(alice.reload.profile).to eq 'ありすです。'
      end
    end
  end
end
