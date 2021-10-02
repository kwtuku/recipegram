require 'rails_helper'

RSpec.describe 'InfiniteScroll', type: :request do
  describe 'home#home' do
    before do
      users = create_list(:user, 20, :no_image)
      users.each do |user|
        create_list(:recipe, 4, :no_image, user: user, updated_at: rand(1..100).minutes.ago)
      end
    end

    let(:not_feed_items) { Recipe.all - feed_items }
    let(:feed_items) { alice.feed.order(updated_at: :DESC) }
    let(:alice) { create :user, :no_image }

    context 'when not signed in and 20 items are already displayed' do
      let(:params) { { displayed_item_count: '20', path: '' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders 20 item links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body.scan(%r{/recipes/\d+}).size).to eq 20
      end
    end

    context 'when not signed in and 40 items are already displayed' do
      let(:params) { { displayed_item_count: '40', path: '' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body.scan(%r{/recipes/\d+}).size).to eq 20
      end
    end

    context 'when signed in and 20 items are already displayed' do
      before do
        random_users = User.all.sample(15)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
        create_list(:recipe, 5, :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
      end

      let(:params) { { displayed_item_count: '20', path: '' } }

      it 'returns a 200 response' do
        sign_in alice
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct item links' do
        sign_in alice
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{feed_items[0].id}"
        expect(response.body).not_to include "/recipes/#{feed_items[19].id}"
        expect(response.body).to include "/recipes/#{feed_items[20].id}"
        expect(response.body).to include "/recipes/#{feed_items[39].id}"
        expect(response.body).not_to include "/recipes/#{feed_items[40].id}"
        expect(response.body).not_to include "/recipes/#{feed_items[59].id}"
        expect(response.body).not_to include "/recipes/#{not_feed_items.sample.id}"
      end
    end

    context 'when signed in and 40 items are already displayed' do
      before do
        random_users = User.all.sample(15)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
        create_list(:recipe, 5, :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
      end

      let(:params) { { displayed_item_count: '40', path: '' } }

      it 'returns a 200 response' do
        sign_in alice
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items links' do
        sign_in alice
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{feed_items[0].id}"
        expect(response.body).not_to include "/recipes/#{feed_items[39].id}"
        expect(response.body).to include "/recipes/#{feed_items[40].id}"
        expect(response.body).to include "/recipes/#{feed_items[59].id}"
        expect(response.body).not_to include "/recipes/#{not_feed_items.sample.id}"
      end
    end
  end

  describe 'recipes#index' do
    before { create_list(:recipe, 100, :no_image) }

    let(:recipes) { Recipe.order(updated_at: :DESC) }

    context 'when 40 items are already displayed' do
      let(:params) { { displayed_item_count: '40', path: 'recipes' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{recipes[0].id}"
        expect(response.body).not_to include "/recipes/#{recipes[39].id}"
        expect(response.body).to include "/recipes/#{recipes[40].id}"
        expect(response.body).to include "/recipes/#{recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{recipes[80].id}"
        expect(response.body).not_to include "/recipes/#{recipes[99].id}"
      end
    end

    context 'when 80 items are already displayed' do
      let(:params) { { displayed_item_count: '80', path: 'recipes' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{recipes[0].id}"
        expect(response.body).not_to include "/recipes/#{recipes[79].id}"
        expect(response.body).to include "/recipes/#{recipes[80].id}"
        expect(response.body).to include "/recipes/#{recipes[99].id}"
      end
    end
  end

  describe 'users#index' do
    before { create_list(:user, 100, :no_image) }

    let(:users) { User.order(id: :DESC) }

    context 'when 40 items are already displayed' do
      let(:params) { { displayed_item_count: '40', path: 'users' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include users[0].nickname.to_s
        expect(response.body).not_to include users[39].nickname.to_s
        expect(response.body).to include users[40].nickname.to_s
        expect(response.body).to include users[79].nickname.to_s
        expect(response.body).not_to include users[80].nickname.to_s
        expect(response.body).not_to include users[99].nickname.to_s
      end
    end

    context 'when 80 items are already displayed' do
      let(:params) { { displayed_item_count: '80', path: 'users' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include users[0].nickname.to_s
        expect(response.body).not_to include users[79].nickname.to_s
        expect(response.body).to include users[80].nickname.to_s
        expect(response.body).to include users[99].nickname.to_s
      end
    end
  end

  describe 'users#show' do
    before { create_list(:recipe, 100, :no_image, user: alice) }

    let!(:alice) { create :user, :no_image, username: 'alice' }
    let(:posted_recipes) { alice.recipes.order(id: :DESC) }
    let!(:not_posted_recipes) { create_list(:recipe, 10, :no_image) }

    context 'when 40 items are already displayed' do
      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{posted_recipes[0].id}"
        expect(response.body).not_to include "/recipes/#{posted_recipes[39].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[40].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{posted_recipes[80].id}"
        expect(response.body).not_to include "/recipes/#{posted_recipes[99].id}"
        expect(response.body).not_to include "/recipes/#{not_posted_recipes.sample.id}"
      end
    end

    context 'when 80 items are already displayed' do
      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{posted_recipes[0].id}"
        expect(response.body).not_to include "/recipes/#{posted_recipes[79].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[80].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[99].id}"
        expect(response.body).not_to include "/recipes/#{not_posted_recipes.sample.id}"
      end
    end
  end

  describe 'users#comments' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    let(:commented_recipes) { alice.commented_recipes.order('comments.created_at desc') }
    let(:not_commented_recipes) { Recipe.all - commented_recipes }

    before do
      create_list(:recipe, 110, :no_image)
      random_recipes = Recipe.all.sample(100)
      random_recipes.each { |recipe| create :comment, user: alice, recipe: recipe }
    end

    context 'when 40 items are already displayed' do
      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}/comments" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{commented_recipes[0].id}"
        expect(response.body).not_to include "/recipes/#{commented_recipes[39].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[40].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{commented_recipes[80].id}"
        expect(response.body).not_to include "/recipes/#{commented_recipes[99].id}"
        expect(response.body).not_to include "/recipes/#{not_commented_recipes.sample.id}"
      end
    end

    context 'when 80 items are already displayed' do
      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}/comments" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{commented_recipes[0].id}"
        expect(response.body).not_to include "/recipes/#{commented_recipes[79].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[80].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[99].id}"
        expect(response.body).not_to include "/recipes/#{not_commented_recipes.sample.id}"
      end
    end
  end

  describe 'users#favorites' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    let(:favored_recipes) { alice.favored_recipes.order('favorites.created_at desc') }
    let(:not_favored_recipes) { Recipe.all - favored_recipes }

    before do
      create_list(:recipe, 110, :no_image)
      random_recipes = Recipe.all.sample(100)
      random_recipes.each { |recipe| alice.favorites.create(recipe_id: recipe.id) }
    end

    context 'when 40 items are already displayed' do
      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}/favorites" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{favored_recipes[0].id}"
        expect(response.body).not_to include "/recipes/#{favored_recipes[39].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[40].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{favored_recipes[80].id}"
        expect(response.body).not_to include "/recipes/#{favored_recipes[99].id}"
        expect(response.body).not_to include "/recipes/#{not_favored_recipes.sample.id}"
      end
    end

    context 'when 80 items are already displayed' do
      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}/favorites" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{favored_recipes[0].id}"
        expect(response.body).not_to include "/recipes/#{favored_recipes[79].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[80].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[99].id}"
        expect(response.body).not_to include "/recipes/#{not_favored_recipes.sample.id}"
      end
    end
  end

  describe 'users#followers' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    let(:followers) { alice.followers.order('relationships.created_at desc') }
    let(:not_followers) { User.all - [alice] - followers }

    before do
      create_list(:user, 110, :no_image)
      random_users = User.all.sample(100)
      random_users.each { |user| user.relationships.create(follow_id: alice.id) }
    end

    context 'when 40 items are already displayed' do
      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}/followers" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include followers[0].nickname.to_s
        expect(response.body).not_to include followers[39].nickname.to_s
        expect(response.body).to include followers[40].nickname.to_s
        expect(response.body).to include followers[79].nickname.to_s
        expect(response.body).not_to include followers[80].nickname.to_s
        expect(response.body).not_to include followers[99].nickname.to_s
        expect(response.body).not_to include not_followers.sample.id.to_s
      end
    end

    context 'when 80 items are already displayed' do
      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}/followers" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include followers[0].nickname.to_s
        expect(response.body).not_to include followers[79].nickname.to_s
        expect(response.body).to include followers[80].nickname.to_s
        expect(response.body).to include followers[99].nickname.to_s
        expect(response.body).not_to include not_followers.sample.id.to_s
      end
    end
  end

  describe 'users#followings' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    let(:followings) { alice.followings.order('relationships.created_at desc') }
    let(:not_followings) { User.all - [alice] - followings }

    before do
      create_list(:user, 110, :no_image)
      random_users = User.all.sample(100)
      random_users.each { |user| alice.relationships.create(follow_id: user.id) }
    end

    context 'when 40 items are already displayed' do
      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}/followings" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include followings[0].nickname.to_s
        expect(response.body).not_to include followings[39].nickname.to_s
        expect(response.body).to include followings[40].nickname.to_s
        expect(response.body).to include followings[79].nickname.to_s
        expect(response.body).not_to include followings[80].nickname.to_s
        expect(response.body).not_to include followings[99].nickname.to_s
        expect(response.body).not_to include not_followings.sample.id.to_s
      end
    end

    context 'when 80 items are already displayed' do
      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}/followings" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include followings[0].nickname.to_s
        expect(response.body).not_to include followings[79].nickname.to_s
        expect(response.body).to include followings[80].nickname.to_s
        expect(response.body).to include followings[99].nickname.to_s
        expect(response.body).not_to include not_followings.sample.id.to_s
      end
    end
  end
end
