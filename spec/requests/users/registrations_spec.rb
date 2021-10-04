require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe '#confirm_destroy' do
    let(:alice) { create :user, :no_image }

    context 'when not signed in' do
      it 'returns a 302 response' do
        get users_confirm_destroy_path
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        get users_confirm_destroy_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      it 'returns a 200 response' do
        sign_in alice
        get users_confirm_destroy_path
        expect(response.status).to eq 200
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create :user, :no_image }

    context 'when not signed in' do
      it 'returns a 302 response' do
        delete user_registration_path
        expect(response.status).to eq 302
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

      it 'returns a 200 response' do
        delete user_registration_path(alice), params: { user: { current_password: 'wrong_password' } }
        expect(response.status).to eq 200
      end

      it 'does not decreases User count' do
        expect do
          delete user_registration_path, params: { user: { current_password: 'wrong_password' } }
        end.to change(User, :count).by(0)
      end
    end

    context 'when signed in and with right password' do
      before { sign_in alice }

      it 'returns a 302 response' do
        delete user_registration_path, params: { user: { current_password: alice.password } }
        expect(response.status).to eq 302
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
