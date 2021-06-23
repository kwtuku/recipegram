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
end
