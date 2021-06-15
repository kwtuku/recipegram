require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/:id/edit" do
    let(:user) { create :user, username: 'user' }
    let(:other_user) { create :user, username: 'other_user' }

    context 'not signed in' do
      it 'redirecto_to new_user_registration_path' do
        get edit_user_path(user)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
