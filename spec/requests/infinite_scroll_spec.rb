require 'rails_helper'

RSpec.describe 'InfiniteScroll', type: :request do
  describe 'home#home' do
    before do
      users = create_list(:user, 20, :no_image)
      users.each do |user|
        4.times do
          create :recipe, :no_image, user: user, updated_at: rand(1..100).minutes.ago
        end
      end
    end

    context 'when not signed in and 20 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '20', path: '' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders 20 item links' do
        get infinite_scroll_path, params: {displayed_item_count: '20', path: '' }, xhr: true
        expect(response.body.scan(/\/recipes\/\d+/).size).to eq 20
      end
    end

    context 'when not signed in and 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: '' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: '' }, xhr: true
        expect(response.body.scan(/\/recipes\/\d+/).size).to eq 20
      end
    end

    let(:alice) { create :user, :no_image }
    let(:feed_items) { alice.feed.order(updated_at: :DESC) }
    let(:not_feed_items) { Recipe.all - feed_items }

    context 'when signed in and 20 items are already displayed' do
      before do
        random_users = User.all.sample(15)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
        create_list(:recipe, 5, :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
      end

      it 'returns a 200 response' do
        sign_in alice
        get infinite_scroll_path, params: {displayed_item_count: '20', path: '' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        sign_in alice
        get infinite_scroll_path, params: {displayed_item_count: '20', path: '' }, xhr: true
        expect(response.body).to_not include "/recipes/#{feed_items[0].id}"
        expect(response.body).to_not include "/recipes/#{feed_items[19].id}"
        expect(response.body).to include "/recipes/#{feed_items[20].id}"
        expect(response.body).to include "/recipes/#{feed_items[39].id}"
        expect(response.body).to_not include "/recipes/#{feed_items[40].id}"
        expect(response.body).to_not include "/recipes/#{feed_items[59].id}"
        expect(response.body).to_not include "/recipes/#{not_feed_items.sample.id}"
      end
    end

    context 'when signed in and 40 items are already displayed' do
      before do
        random_users = User.all.sample(15)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
        create_list(:recipe, 5, :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
      end

      it 'returns a 200 response' do
        sign_in alice
        get infinite_scroll_path, params: {displayed_item_count: '40', path: '' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        sign_in alice
        get infinite_scroll_path, params: {displayed_item_count: '40', path: '' }, xhr: true
        expect(response.body).to_not include "/recipes/#{feed_items[0].id}"
        expect(response.body).to_not include "/recipes/#{feed_items[39].id}"
        expect(response.body).to include "/recipes/#{feed_items[40].id}"
        expect(response.body).to include "/recipes/#{feed_items[59].id}"
        expect(response.body).to_not include "/recipes/#{not_feed_items.sample.id}"
      end
    end
  end

  describe 'recipes#index' do
    before { create_list(:recipe, 100, :no_image) }
    let(:recipes) { Recipe.order(updated_at: :DESC) }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: 'recipes' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: 'recipes' }, xhr: true
        expect(response.body).to_not include "/recipes/#{recipes[0].id}"
        expect(response.body).to_not include "/recipes/#{recipes[39].id}"
        expect(response.body).to include "/recipes/#{recipes[40].id}"
        expect(response.body).to include "/recipes/#{recipes[79].id}"
        expect(response.body).to_not include "/recipes/#{recipes[80].id}"
        expect(response.body).to_not include "/recipes/#{recipes[99].id}"
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: 'recipes' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: 'recipes' }, xhr: true
        expect(response.body).to_not include "/recipes/#{recipes[0].id}"
        expect(response.body).to_not include "/recipes/#{recipes[79].id}"
        expect(response.body).to include "/recipes/#{recipes[80].id}"
        expect(response.body).to include "/recipes/#{recipes[99].id}"
      end
    end
  end

  describe 'users#index' do
    before { create_list(:user, 100, :no_image) }
    let(:users) { User.order(id: :DESC) }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: 'users' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: 'users' }, xhr: true
        expect(response.body).to_not include "#{users[0].nickname}"
        expect(response.body).to_not include "#{users[39].nickname}"
        expect(response.body).to include "#{users[40].nickname}"
        expect(response.body).to include "#{users[79].nickname}"
        expect(response.body).to_not include "#{users[80].nickname}"
        expect(response.body).to_not include "#{users[99].nickname}"
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: 'users' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: 'users' }, xhr: true
        expect(response.body).to_not include "#{users[0].nickname}"
        expect(response.body).to_not include "#{users[79].nickname}"
        expect(response.body).to include "#{users[80].nickname}"
        expect(response.body).to include "#{users[99].nickname}"
      end
    end
  end

  describe 'users#show' do
    let!(:alice) { create :user, :no_image, username: 'alice' }
    let!(:alice_recipes) { create_list(:recipe, 100, :no_image, user: alice) }
    let(:posted_recipes) { alice.recipes.order(id: :DESC) }
    let!(:not_posted_recipes) { create_list(:recipe, 10, :no_image) }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}" }, xhr: true
        expect(response.body).to_not include "/recipes/#{posted_recipes[0].id}"
        expect(response.body).to_not include "/recipes/#{posted_recipes[39].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[40].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[79].id}"
        expect(response.body).to_not include "/recipes/#{posted_recipes[80].id}"
        expect(response.body).to_not include "/recipes/#{posted_recipes[99].id}"
        expect(response.body).to_not include "/recipes/#{not_posted_recipes.sample.id}"
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}" }, xhr: true
        expect(response.body).to_not include "/recipes/#{posted_recipes[0].id}"
        expect(response.body).to_not include "/recipes/#{posted_recipes[79].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[80].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[99].id}"
        expect(response.body).to_not include "/recipes/#{not_posted_recipes.sample.id}"
      end
    end
  end

  describe 'users#comments' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    before do
      create_list(:recipe, 110, :no_image)
      random_recipes = Recipe.all.sample(100)
      random_recipes.each { |recipe| create :comment, user: alice, recipe: recipe }
    end
    let(:commented_recipes) { alice.commented_recipes.order('comments.created_at desc') }
    let(:not_commented_recipes) { Recipe.all - commented_recipes }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/comments" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '40',  path: "users/#{alice.username}/comments" }, xhr: true
        expect(response.body).to_not include "/recipes/#{commented_recipes[0].id}"
        expect(response.body).to_not include "/recipes/#{commented_recipes[39].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[40].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[79].id}"
        expect(response.body).to_not include "/recipes/#{commented_recipes[80].id}"
        expect(response.body).to_not include "/recipes/#{commented_recipes[99].id}"
        expect(response.body).to_not include "/recipes/#{not_commented_recipes.sample.id}"
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/comments" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/comments" }, xhr: true
        expect(response.body).to_not include "/recipes/#{commented_recipes[0].id}"
        expect(response.body).to_not include "/recipes/#{commented_recipes[79].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[80].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[99].id}"
        expect(response.body).to_not include "/recipes/#{not_commented_recipes.sample.id}"
      end
    end
  end

  describe 'users#favorites' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    before do
      create_list(:recipe, 110, :no_image)
      random_recipes = Recipe.all.sample(100)
      random_recipes.each { |recipe| alice.favorites.create(recipe_id: recipe.id) }
    end
    let(:favored_recipes) { alice.favored_recipes.order('favorites.created_at desc') }
    let(:not_favored_recipes) { Recipe.all - favored_recipes }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/favorites" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/favorites" }, xhr: true
        expect(response.body).to_not include "/recipes/#{favored_recipes[0].id}"
        expect(response.body).to_not include "/recipes/#{favored_recipes[39].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[40].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[79].id}"
        expect(response.body).to_not include "/recipes/#{favored_recipes[80].id}"
        expect(response.body).to_not include "/recipes/#{favored_recipes[99].id}"
        expect(response.body).to_not include "/recipes/#{not_favored_recipes.sample.id}"
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/favorites" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/favorites" }, xhr: true
        expect(response.body).to_not include "/recipes/#{favored_recipes[0].id}"
        expect(response.body).to_not include "/recipes/#{favored_recipes[79].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[80].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[99].id}"
        expect(response.body).to_not include "/recipes/#{not_favored_recipes.sample.id}"
      end
    end
  end

  describe 'users#followers' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    before do
      create_list(:user, 110, :no_image)
      random_users = User.all.sample(100)
      random_users.each { |user| user.relationships.create(follow_id: alice.id) }
    end
    let(:followers) { alice.followers.order('relationships.created_at desc') }
    let(:not_followers) { User.all - [alice] - followers }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/followers" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/followers" }, xhr: true
        expect(response.body).to_not include "#{followers[0].nickname}"
        expect(response.body).to_not include "#{followers[39].nickname}"
        expect(response.body).to include "#{followers[40].nickname}"
        expect(response.body).to include "#{followers[79].nickname}"
        expect(response.body).to_not include "#{followers[80].nickname}"
        expect(response.body).to_not include "#{followers[99].nickname}"
        expect(response.body).to_not include "#{not_followers.sample.id}"
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/followers" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/followers" }, xhr: true
        expect(response.body).to_not include "#{followers[0].nickname}"
        expect(response.body).to_not include "#{followers[79].nickname}"
        expect(response.body).to include "#{followers[80].nickname}"
        expect(response.body).to include "#{followers[99].nickname}"
        expect(response.body).to_not include "#{not_followers.sample.id}"
      end
    end
  end

  describe 'users#followings' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    before do
      create_list(:user, 110, :no_image)
      random_users = User.all.sample(100)
      random_users.each { |user| alice.relationships.create(follow_id: user.id) }
    end
    let(:followings) { alice.followings.order('relationships.created_at desc') }
    let(:not_followings) { User.all - [alice] - followings }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/followings" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/followings" }, xhr: true
        expect(response.body).to_not include "#{followings[0].nickname}"
        expect(response.body).to_not include "#{followings[39].nickname}"
        expect(response.body).to include "#{followings[40].nickname}"
        expect(response.body).to include "#{followings[79].nickname}"
        expect(response.body).to_not include "#{followings[80].nickname}"
        expect(response.body).to_not include "#{followings[99].nickname}"
        expect(response.body).to_not include "#{not_followings.sample.id}"
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/followings" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/followings" }, xhr: true
        expect(response.body).to_not include "#{followings[0].nickname}"
        expect(response.body).to_not include "#{followings[79].nickname}"
        expect(response.body).to include "#{followings[80].nickname}"
        expect(response.body).to include "#{followings[99].nickname}"
        expect(response.body).to_not include "#{not_followings.sample.id}"
      end
    end
  end
end
