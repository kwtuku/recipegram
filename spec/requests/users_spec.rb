require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/:id/edit' do
    let(:user) { create :user, username: 'user' }
    let(:other_user) { create :user, username: 'other_user' }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        get edit_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in as wrong user' do
      it 'redirect_to user_path(user)' do
        sign_in other_user
        get edit_user_path(user)
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'signed in as correct user' do
      it 'returns a 200 response' do
        sign_in user
        get edit_user_path(user)
        expect(response).to have_http_status(200)
      end
    end
  end
end
