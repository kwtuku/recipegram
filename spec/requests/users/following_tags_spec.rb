require 'rails_helper'

RSpec.describe 'Users::FollowingTags', type: :request do
  describe 'GET /users/:user_username/following_tags' do
    let(:alice) { create(:user, :no_image) }

    before do
      tag = create(:tag)
      user = create(:user, :no_image)
      create_list(:recipe, 5, :with_images, images_count: 1, tag_list: tag.name, user: user)
      alice.tag_followings.create!(tag_id: tag.id)
    end

    context 'when not signed in' do
      it 'returns found' do
        get user_following_tags_path(alice)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get user_following_tags_path(alice)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        get user_following_tags_path(alice)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
