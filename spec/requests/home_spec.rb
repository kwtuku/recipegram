require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe '#home' do
    context 'when not signed in' do
      before do
        users = create_list(:user, 8, :no_image)
        users.each do |user|
          create_list :recipe, 3, :no_image, user: user, updated_at: rand(1..100).minutes.ago
        end
      end

      it 'returns a 200 response' do
        get root_path
        expect(response.status).to eq 200
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
      let(:alice) { create :user, :no_image }
      let(:feeds) { alice.feed.order(updated_at: :desc) }
      let(:not_feed) { (Recipe.all - feeds).first }

      before do
        users = create_list(:user, 9, :no_image)
        users.each do |user|
        end
        random_users = User.all.sample(3)
        random_users.each do |user|
          alice.relationships.create(follow_id: user.id)
          create_list(:recipe, 6, :no_image, user: user, updated_at: rand(1..100).minutes.ago)
        end
        create_list(:recipe, 3, :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
        create :recipe, :no_image
        sign_in alice
      end

      it 'returns a 200 response' do
        get root_path
        expect(response.status).to eq 200
      end

      it 'renders correct recipe links' do
        get root_path
        expect(response.body).to include "/recipes/#{feeds[0].id}"
        expect(response.body).to include "/recipes/#{feeds[19].id}"
        expect(response.body).not_to include "/recipes/#{feeds[20].id}"
        expect(response.body).not_to include "/recipes/#{not_feed.id}"
      end

      it 'renders 5 recommend users' do
        get root_path
        expect(response.body.scan('rspec_recommend_user').size).to eq 5
      end
    end
  end

  describe '#privacy' do
    let(:alice) { create :user, :no_image }

    it 'returns a 200 response when not signed in' do
      get privacy_path
      expect(response.status).to eq 200
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get privacy_path
      expect(response.status).to eq 200
    end
  end
end
