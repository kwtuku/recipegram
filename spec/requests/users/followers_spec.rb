require 'rails_helper'

RSpec.describe 'Users::Followers', type: :request do
  describe 'POST /users/:user_username/followers' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }

    context 'when not signed in' do
      it 'returns unauthorized' do
        post user_followers_path(bob), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not increase Relationship count' do
        expect do
          post user_followers_path(bob), xhr: true
        end.to change(Relationship, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        post user_followers_path(bob), xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'increases Relationship count' do
        expect do
          post user_followers_path(bob), xhr: true
        end.to change(Relationship, :count).by(1)
      end
    end
  end

  describe 'DELETE /users/:user_username/followers' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }

    before { alice.relationships.create!(follow_id: bob.id) }

    context 'when not signed in' do
      it 'returns unauthorized' do
        delete user_followers_path(bob), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not decrease Relationship count' do
        expect do
          delete user_followers_path(bob), xhr: true
        end.to change(Relationship, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        delete user_followers_path(bob), xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'decreases Relationship count' do
        expect do
          delete user_followers_path(bob), xhr: true
        end.to change(Relationship, :count).by(-1)
      end
    end
  end
end
