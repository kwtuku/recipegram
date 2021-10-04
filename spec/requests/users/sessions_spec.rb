require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe '#guest_sign_in' do
    it 'returns a 302 response' do
      post users_guest_sign_in_path
      expect(response.status).to eq 302
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
