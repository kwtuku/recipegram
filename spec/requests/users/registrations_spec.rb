require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'GET /users/confirm_destroy' do
    let(:alice) { create(:user) }

    context 'when not signed in' do
      it 'returns found' do
        get users_confirm_destroy_path
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get users_confirm_destroy_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      it 'returns ok' do
        sign_in alice
        get users_confirm_destroy_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /users' do
    let(:alice) { create(:user) }

    context 'when not signed in' do
      it 'returns found' do
        delete user_registration_path
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        delete user_registration_path
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not decrease User count' do
        expect do
          delete user_registration_path
        end.to change(User, :count).by(0)
      end
    end

    context 'when signed in and with wrong password' do
      before { sign_in alice }

      it 'returns ok' do
        delete user_registration_path(alice), params: { user: { current_password: 'wrong_password' } }
        expect(response).to have_http_status(:ok)
      end

      it 'does not decreases User count' do
        expect do
          delete user_registration_path, params: { user: { current_password: 'wrong_password' } }
        end.to change(User, :count).by(0)
      end
    end

    context 'when signed in and with right password' do
      before { sign_in alice }

      it 'returns found' do
        delete user_registration_path, params: { user: { current_password: alice.password } }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to root_path' do
        sign_in alice
        delete user_registration_path, params: { user: { current_password: alice.password } }
        expect(response).to redirect_to root_path
      end

      it 'decreases User count' do
        expect do
          delete user_registration_path, params: { user: { current_password: alice.password } }
        end.to change(User, :count).by(-1)
      end
    end
  end
end
