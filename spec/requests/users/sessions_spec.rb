require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  describe 'POST /users/guest_sign_in' do
    it 'returns found' do
      post users_guest_sign_in_path
      expect(response).to have_http_status(:found)
    end

    it 'redirects to root_path' do
      post users_guest_sign_in_path
      expect(response).to redirect_to root_path
    end

    it 'signs in as guest user' do
      post users_guest_sign_in_path
      guest_user = User.find_by(email: 'guest@example.com')
      expect(controller.current_user).to eq guest_user
    end
  end
end
