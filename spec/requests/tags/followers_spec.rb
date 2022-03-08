require 'rails_helper'

RSpec.describe 'Tags::Followers', type: :request do
  describe 'POST /tags/:tag_name/followers' do
    let(:alice) { create(:user, :no_image) }
    let(:tag) { create(:tag) }

    context 'when not signed in' do
      it 'returns unauthorized' do
        post tag_followers_path(tag.name), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not increase TagFollowing count' do
        expect do
          post tag_followers_path(tag.name), xhr: true
        end.to change(TagFollowing, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        post tag_followers_path(tag.name), xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'increases TagFollowing count' do
        expect do
          post tag_followers_path(tag.name), xhr: true
        end.to change(TagFollowing, :count).by(1)
      end
    end
  end

  describe 'DELETE /tags/:tag_name/followers' do
    let(:alice) { create(:user, :no_image) }
    let(:tag) { create(:tag) }

    before { alice.tag_followings.create(tag_id: tag.id) }

    context 'when not signed in' do
      it 'returns unauthorized' do
        delete tag_followers_path(tag.name), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not decrease TagFollowing count' do
        expect do
          delete tag_followers_path(tag.name), xhr: true
        end.to change(TagFollowing, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        delete tag_followers_path(tag.name), xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'decreases TagFollowing count' do
        expect do
          delete tag_followers_path(tag.name), xhr: true
        end.to change(TagFollowing, :count).by(-1)
      end
    end
  end
end
