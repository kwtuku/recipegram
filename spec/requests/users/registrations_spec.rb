require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe '#confirm_destroy' do
    let(:alice) { create :user, :no_image }

    it 'redirects to new_user_session_path when not signed in' do
      get users_confirm_destroy_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get users_confirm_destroy_path
      expect(response).to have_http_status(200)
    end
  end

  describe '#destroy' do
    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        delete user_registration_path(nil)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase User count' do
        expect {
          delete user_registration_path(nil)
        }.to change { User.count }.by(0)
      end
    end

    let(:alice) { create :user, :no_image }

    context 'when signed in and with wrong password' do
      it 'does not decreases User count' do
        sign_in alice
        expect{
          delete user_registration_path, params: { user: { current_password: 'wrong_password' } }
        }.to change { User.count }.by(0)
      end

      it 'returns a 200 response' do
        sign_in alice
        delete user_registration_path(alice), params: { user: { current_password: 'wrong_password' } }
        expect(response).to have_http_status(200)
      end
    end

    context 'when signed in and with right password' do
      it 'decreases User count' do
        sign_in alice
        expect{
          delete user_registration_path, params: { user: { current_password: alice.password } }
        }.to change { User.count }.by(-1)
      end

      it 'returns a 302 response' do
        sign_in alice
        delete user_registration_path, params: { user: { current_password: alice.password } }
        expect(response).to have_http_status(302)
      end

      it 'redirects to root_path' do
        sign_in alice
        delete user_registration_path, params: { user: { current_password: alice.password } }
        expect(response).to redirect_to root_path
      end
    end
  end
end
