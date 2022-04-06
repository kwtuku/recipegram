require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /' do
    context 'when not signed in' do
      before do
        users = create_list(:user, 8)
        users.each { |user| create_list(:recipe, 3, :with_images, images_count: 1, user: user) }
      end

      it 'returns ok' do
        get root_path
        expect(response).to have_http_status(:ok)
      end

      it 'renders 20 recipe links' do
        get root_path
        expect(response.body.scan(%r{/recipes/\d+}).size).to eq 20
      end

      it 'renders 7 recommend users' do
        get root_path
        expect(response.body.scan('rspec_recommend_user').size).to eq 7
      end
    end

    context 'when signed in' do
      let(:alice) { create(:user) }
      let(:feed) { alice.feed.order(id: :desc) }
      let(:not_feed) { Recipe.where.not(id: feed.ids).first }

      before do
        create(:recipe, :with_images, images_count: 1)
        random_users = create_list(:user, 9).sample(3)
        random_users.each do |user|
          alice.relationships.create(follow_id: user.id)
          create_list(:recipe, 6, :with_images, images_count: 1, user: user)
        end
        create_list(:recipe, 3, :with_images, images_count: 1, user: alice)
        sign_in alice
      end

      it 'returns ok' do
        get root_path
        expect(response).to have_http_status(:ok)
      end

      it 'renders correct recipe links' do
        get root_path
        expect(response.body).to include "/recipes/#{feed[0].id}"
        expect(response.body).to include "/recipes/#{feed[19].id}"
        expect(response.body).not_to include "/recipes/#{feed[20].id}"
        expect(response.body).not_to include "/recipes/#{not_feed.id}"
      end

      it 'renders 5 recommend users' do
        get root_path
        expect(response.body.scan('rspec_recommend_user').size).to eq 5
      end
    end
  end

  describe 'GET /privacy' do
    let(:alice) { create(:user) }

    it 'returns ok when not signed in' do
      get privacy_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns ok when signed in' do
      sign_in alice
      get privacy_path
      expect(response).to have_http_status(:ok)
    end
  end
end
