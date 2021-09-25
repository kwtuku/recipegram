require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe '#home' do
    before do
      users = create_list(:user, 15, :no_image)
      users.each do |user|
        2.times do
          create :recipe, :no_image, user: user, updated_at: rand(1..100).minutes.ago
        end
      end
    end

    context 'when not signed in' do
      it 'returns a 200 response' do
        get root_path
        expect(response).to have_http_status(200)
      end

      it 'renders 20 recipe links' do
        get root_path
        expect(response.body.scan(/\/recipes\/\d+/).size).to eq 20
      end

      it 'renders 7 recommend users' do
        get root_path
        expect(response.body.scan('rspec_recommend_user').size).to eq 7
      end
    end

    let(:alice) { create :user, :no_image }
    let(:feed_items) { alice.feed.order(updated_at: :DESC) }
    let(:not_feed_items) { Recipe.all - feed_items }

    context 'when signed in' do
      before do
        random_users = User.all.sample(10)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
        create_list(:recipe, 5, :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
      end

      it 'returns a 200 response' do
        sign_in alice
        get root_path
        expect(response).to have_http_status(200)
      end

      it 'renders correct recipe links' do
        sign_in alice
        get root_path
        expect(response.body).to include "/recipes/#{feed_items[0].id}"
        expect(response.body).to include "/recipes/#{feed_items[19].id}"
        expect(response.body).to_not include "/recipes/#{feed_items[20].id}"
        expect(response.body).to_not include "/recipes/#{not_feed_items.sample.id}"
      end

      it 'renders 5 recommend users' do
        sign_in alice
        get root_path
        expect(response.body.scan('rspec_recommend_user').size).to eq 5
      end
    end
  end

  describe '#privacy' do
    let(:alice) { create :user, :no_image }

    it 'returns a 200 response when not signed in' do
      get privacy_path
      expect(response).to have_http_status(200)
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get privacy_path
      expect(response).to have_http_status(200)
    end
  end
end
