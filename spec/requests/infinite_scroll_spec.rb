require 'rails_helper'

RSpec.describe 'InfiniteScroll', type: :request do
  describe 'home#home' do
    before do
      users = create_list(:user, 60, :no_image)
      users.each do |user|
        rand(1..5).times do
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
        random_users = User.all.sample(40)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
        create_list(:recipe, rand(1..10), :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
      end

      it 'returns a 200 response' do
        sign_in alice
        get infinite_scroll_path, params: {displayed_item_count: '20', path: '' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        sign_in alice
        get infinite_scroll_path, params: {displayed_item_count: '20', path: '' }, xhr: true
        feed_items[0..19].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        feed_items[20..39].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        feed_items[40..59].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        not_feed_items.pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end

    context 'when signed in and 40 items are already displayed' do
      before do
        random_users = User.all.sample(40)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
        create_list(:recipe, rand(1..10), :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
      end

      it 'returns a 200 response' do
        sign_in alice
        get infinite_scroll_path, params: {displayed_item_count: '40', path: '' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        sign_in alice
        get infinite_scroll_path, params: {displayed_item_count: '40', path: '' }, xhr: true
        feed_items[0..39].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        feed_items[40..59].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        not_feed_items.pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end
  end

  describe 'recipes#index' do
    before { create_list(:recipe, 100, :no_image) }
    let(:recipes) { Recipe.eager_load(:favorites, :comments).order(updated_at: :DESC) }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: 'recipes' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: 'recipes' }, xhr: true
        recipes[0..39].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        recipes[40..79].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        recipes[80..99].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: 'recipes' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: 'recipes' }, xhr: true
        recipes[0..79].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        recipes[80..99].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
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
        users[0..39].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
        users[40..79].pluck(:nickname).each { |nickname| expect(response.body).to include nickname }
        users[80..99].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: 'users' }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: 'users' }, xhr: true
        users[0..79].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
        users[80..99].pluck(:nickname).each { |nickname| expect(response.body).to include nickname }
      end
    end
  end

  describe 'users#show' do
    let!(:alice) { create :user, :no_image, username: 'alice' }
    let!(:alice_recipes) { create_list(:recipe, 100, :no_image, user: alice) }
    let(:posted_recipes) { alice.recipes.eager_load(:favorites, :comments).order(id: :DESC) }
    let!(:not_posted_recipes) { create_list(:recipe, 10, :no_image) }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}" }, xhr: true
        posted_recipes[0..39].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        posted_recipes[40..79].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        posted_recipes[80..99].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        not_posted_recipes.pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}" }, xhr: true
        posted_recipes[0..79].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        posted_recipes[80..99].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        not_posted_recipes.pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end
  end

  describe 'users#comments' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    before do
      create_list(:recipe, 120, :no_image)
      random_recipes = Recipe.all.sample(100)
      random_recipes.each { |recipe| create :comment, user: alice, recipe: recipe }
    end
    let(:commented_recipes) { alice.commented_recipes.eager_load(:favorites, :comments).order('comments.created_at desc') }
    let(:not_commented_recipes) { Recipe.all - commented_recipes }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/comments" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '40',  path: "users/#{alice.username}/comments" }, xhr: true
        commented_recipes[0..39].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        commented_recipes[40..79].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        commented_recipes[80..99].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        not_commented_recipes.pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/comments" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/comments" }, xhr: true
        commented_recipes[0..79].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        commented_recipes[80..99].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        not_commented_recipes.pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end
  end

  describe 'users#favorites' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    before do
      create_list(:recipe, 120, :no_image)
      random_recipes = Recipe.all.sample(100)
      random_recipes.each { |recipe| alice.favorites.create(recipe_id: recipe.id) }
    end
    let(:favored_recipes) { alice.favored_recipes.eager_load(:favorites, :comments).order('favorites.created_at desc') }
    let(:not_favored_recipes) { Recipe.all - favored_recipes }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/favorites" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct item links' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/favorites" }, xhr: true
        favored_recipes[0..39].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        favored_recipes[40..79].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        favored_recipes[80..99].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        not_favored_recipes.pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/favorites" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items links' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/favorites" }, xhr: true
        favored_recipes[0..79].pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
        favored_recipes[80..99].pluck(:id).each { |recipe_id| expect(response.body).to include "/recipes/#{recipe_id}" }
        not_favored_recipes.pluck(:id).each { |recipe_id| expect(response.body).to_not include "/recipes/#{recipe_id}" }
      end
    end
  end

  describe 'users#followers' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    before do
      create_list(:user, 120, :no_image)
      random_users = User.all.sample(100)
      random_users.each { |user| user.relationships.create(follow_id: alice.id) }
    end
    let(:followers) { alice.followers.preload(:followings).order('relationships.created_at desc') }
    let(:not_followers) { User.all - [alice] - followers }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/followers" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/followers" }, xhr: true
        followers[0..39].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
        followers[40..79].pluck(:nickname).each { |nickname| expect(response.body).to include nickname }
        followers[80..99].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
        not_followers.pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/followers" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/followers" }, xhr: true
        followers[0..79].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
        followers[80..99].pluck(:nickname).each { |nickname| expect(response.body).to include nickname }
        not_followers.pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
      end
    end
  end

  describe 'users#followings' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    before do
      create_list(:user, 120, :no_image)
      random_users = User.all.sample(100)
      random_users.each { |user| alice.relationships.create(follow_id: user.id) }
    end
    let(:followings) { alice.followings.preload(:followings).order('relationships.created_at desc') }
    let(:not_followings) { User.all - [alice] - followings }

    context 'when 40 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/followings" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '40', path: "users/#{alice.username}/followings" }, xhr: true
        followings[0..39].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
        followings[40..79].pluck(:nickname).each { |nickname| expect(response.body).to include nickname }
        followings[80..99].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
        not_followings.pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
      end
    end

    context 'when 80 items are already displayed' do
      it 'returns a 200 response' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/followings" }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'renders correct items' do
        get infinite_scroll_path, params: {displayed_item_count: '80', path: "users/#{alice.username}/followings" }, xhr: true
        followings[0..79].pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
        followings[80..99].pluck(:nickname).each { |nickname| expect(response.body).to include nickname }
        not_followings.pluck(:nickname).each { |nickname| expect(response.body).to_not include nickname }
      end
    end
  end
end
