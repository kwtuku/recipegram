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

  describe 'GET /search' do
    before do
      alice = create(:user, nickname: 'アリス', profile: '味噌ラーメンが好き')
      create(:user, nickname: 'ボブ', profile: 'しょうゆらーめんが好き')
      create(:user, nickname: 'キャロル', profile: '塩らーめんが好き')
      create(:user, nickname: 'dave', profile: 'I like tonkotsu ramen')

      create(:recipe, :with_images, images_count: 1, title: '味噌ラーメン', body: '味噌ラーメンの作り方', tag_list: 'ラーメン', user: alice)
      create(:recipe, :with_images, images_count: 1, title: 'しょうゆラーメン', body: 'しょうゆラーメンの作り方', user: alice)
      create(:recipe, :with_images, images_count: 1, title: '塩ラーメン', body: '塩ラーメンの作り方', tag_list: '塩ラーメン', user: alice)
      create(:recipe, :with_images, images_count: 1, title: 'とんこつらーめん', body: '豚骨ラーメンの作り方', user: alice)
    end

    context 'when no result' do
      it 'returns ok' do
        get search_path(q: 'ごはん')
        expect(response).to have_http_status(:ok)
      end

      it 'renders correct result counts' do
        get search_path(q: 'ごはん')
        expect(response.body).to include '「ごはん」は見つかりませんでした。'
        expect(response.body).to include 'data-rspec="recipe_title_result_count_0"'
        expect(response.body).to include 'data-rspec="recipe_body_result_count_0"'
        expect(response.body).to include 'data-rspec="user_nickname_result_count_0"'
        expect(response.body).to include 'data-rspec="user_profile_result_count_0"'
        expect(response.body).to include 'data-rspec="tag_name_result_count_0"'
      end
    end

    context 'when result exists' do
      it 'returns ok' do
        get search_path(q: 'ラーメン')
        expect(response).to have_http_status(:ok)
      end

      it 'renders correct result counts' do
        get search_path(q: 'ラーメン')
        expect(response.body).to include '「ラーメン」の検索結果'
        expect(response.body).to include 'data-rspec="recipe_title_result_count_3"'
        expect(response.body).to include 'data-rspec="recipe_body_result_count_4"'
        expect(response.body).to include 'data-rspec="user_nickname_result_count_0"'
        expect(response.body).to include 'data-rspec="user_profile_result_count_1"'
        expect(response.body).to include 'data-rspec="tag_name_result_count_2"'
      end
    end
  end
end
