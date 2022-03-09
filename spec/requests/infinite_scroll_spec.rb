require 'rails_helper'

RSpec.describe 'InfiniteScroll', type: :request do
  describe 'home#home' do
    let(:alice) { create(:user, :no_image) }
    let(:feed) { alice.feed }
    let(:not_feed) { create(:recipe, :no_image) }

    context 'when not signed in and 20 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 14, :no_image, user: user) }
      end

      let(:params) { { displayed_item_count: '20', path: '' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'returns correct link size' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body.scan(%r{/recipes/\d+}).size).to eq 20
      end
    end

    context 'when not signed in and 40 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 21, :no_image, user: user) }
      end

      let(:params) { { displayed_item_count: '40', path: '' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'returns correct link size' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body.scan(%r{/recipes/\d+}).size).to eq 20
      end
    end

    context 'when signed in and 20 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each do |user|
          create_list(:recipe, 10, :no_image, user: user)
          alice.relationships.create(follow_id: user.id)
        end
        create_list(:recipe, 11, :no_image, user: alice)

        sign_in alice
      end

      let(:params) { { displayed_item_count: '20', path: '' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{feed[19].id}"
        expect(response.body).to include "/recipes/#{feed[20].id}"
        expect(response.body).to include "/recipes/#{feed[39].id}"
        expect(response.body).not_to include "/recipes/#{feed[40].id}"
        expect(response.body).not_to include "/recipes/#{not_feed.id}"
      end
    end

    context 'when signed in and 40 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each do |user|
          create_list(:recipe, 17, :no_image, user: user)
          alice.relationships.create(follow_id: user.id)
        end
        create_list(:recipe, 11, :no_image, user: alice)

        sign_in alice
      end

      let(:params) { { displayed_item_count: '40', path: '' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{feed[39].id}"
        expect(response.body).to include "/recipes/#{feed[40].id}"
        expect(response.body).to include "/recipes/#{feed[59].id}"
        expect(response.body).not_to include "/recipes/#{feed[60].id}"
        expect(response.body).not_to include "/recipes/#{not_feed.id}"
      end
    end
  end

  describe 'recipes#index' do
    let(:recipes) { Recipe.order(id: :desc) }

    context 'when 40 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 27, :no_image, user: user) }
      end

      let(:params) { { displayed_item_count: '40', path: 'recipes' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{recipes[39].id}"
        expect(response.body).to include "/recipes/#{recipes[40].id}"
        expect(response.body).to include "/recipes/#{recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{recipes[80].id}"
      end
    end

    context 'when 80 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 41, :no_image, user: user) }
      end

      let(:params) { { displayed_item_count: '80', path: 'recipes' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{recipes[79].id}"
        expect(response.body).to include "/recipes/#{recipes[80].id}"
        expect(response.body).to include "/recipes/#{recipes[119].id}"
        expect(response.body).not_to include "/recipes/#{recipes[120].id}"
      end
    end
  end

  describe 'tags#show' do
    context 'when the tag name contains japanese' do
      let(:recipes_with_japanese_tag) { Recipe.tagged_with(tag_name_with_japanese).order(id: :desc) }
      let(:tag_name_with_japanese) { 'かんたん' }
      let(:encoded_tag_name) { URI.encode_www_form_component(tag_name_with_japanese) }
      let(:params) { { displayed_item_count: '40', path: "tags/#{encoded_tag_name}" } }

      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 27, :no_image, user: user, tag_list: tag_name_with_japanese) }
      end

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{recipes_with_japanese_tag[39].id}"
        expect(response.body).to include "/recipes/#{recipes_with_japanese_tag[40].id}"
        expect(response.body).to include "/recipes/#{recipes_with_japanese_tag[79].id}"
        expect(response.body).not_to include "/recipes/#{recipes_with_japanese_tag[80].id}"
      end
    end

    context 'when 40 items are already displayed' do
      let(:tagged_recipes) { Recipe.tagged_with(tag_name).order(id: :desc) }
      let(:tag_name) { 'easy' }
      let(:params) { { displayed_item_count: '40', path: "tags/#{tag_name}" } }

      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 27, :no_image, user: user, tag_list: tag_name) }
      end

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{tagged_recipes[39].id}"
        expect(response.body).to include "/recipes/#{tagged_recipes[40].id}"
        expect(response.body).to include "/recipes/#{tagged_recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{tagged_recipes[80].id}"
      end
    end

    context 'when 80 items are already displayed' do
      let(:tagged_recipes) { Recipe.tagged_with(tag_name).order(id: :desc) }
      let(:tag_name) { 'easy' }
      let(:params) { { displayed_item_count: '80', path: "tags/#{tag_name}" } }

      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 41, :no_image, user: user, tag_list: tag_name) }
      end

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{tagged_recipes[79].id}"
        expect(response.body).to include "/recipes/#{tagged_recipes[80].id}"
        expect(response.body).to include "/recipes/#{tagged_recipes[119].id}"
        expect(response.body).not_to include "/recipes/#{tagged_recipes[120].id}"
      end
    end
  end

  describe 'users#index' do
    let(:users) { User.order(id: :desc) }

    context 'when 40 items are already displayed' do
      before { create_list(:user, 81, :no_image) }

      let(:params) { { displayed_item_count: '40', path: 'users' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/users/#{users[39].username}"
        expect(response.body).to include "/users/#{users[40].username}"
        expect(response.body).to include "/users/#{users[79].username}"
        expect(response.body).not_to include "/users/#{users[80].username}"
      end
    end

    context 'when 80 items are already displayed' do
      before { create_list(:user, 121, :no_image) }

      let(:params) { { displayed_item_count: '80', path: 'users' } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/users/#{users[79].username}"
        expect(response.body).to include "/users/#{users[80].username}"
        expect(response.body).to include "/users/#{users[119].username}"
        expect(response.body).not_to include "/users/#{users[120].username}"
      end
    end
  end

  describe 'users#show' do
    let(:alice) { create(:user, :no_image) }
    let(:posted_recipes) { alice.recipes.order(id: :desc) }
    let(:not_posted_recipe) { create(:recipe, :no_image) }

    context 'when 40 items are already displayed' do
      before { create_list(:recipe, 81, :no_image, user: alice) }

      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{posted_recipes[39].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[40].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{posted_recipes[80].id}"
        expect(response.body).not_to include "/recipes/#{not_posted_recipe.id}"
      end
    end

    context 'when 80 items are already displayed' do
      before { create_list(:recipe, 121, :no_image, user: alice) }

      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{posted_recipes[79].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[80].id}"
        expect(response.body).to include "/recipes/#{posted_recipes[119].id}"
        expect(response.body).not_to include "/recipes/#{posted_recipes[120].id}"
        expect(response.body).not_to include "/recipes/#{not_posted_recipe.id}"
      end
    end
  end

  describe 'users#comments' do
    let(:alice) { create(:user, :no_image) }
    let(:commented_recipes) { alice.commented_recipes.order('comments.id desc') }
    let(:not_commented_recipe) { (Recipe.all - commented_recipes).first }

    context 'when 40 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 28, :no_image, user: user) }
        random_recipes = Recipe.all.sample(81)
        random_recipes.each { |recipe| create(:comment, user: alice, recipe: recipe) }
      end

      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}/comments" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{commented_recipes[39].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[40].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{commented_recipes[80].id}"
        expect(response.body).not_to include "/recipes/#{not_commented_recipe.id}"
      end
    end

    context 'when 80 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 41, :no_image, user: user) }
        random_recipes = Recipe.all.sample(121)
        random_recipes.each { |recipe| create(:comment, user: alice, recipe: recipe) }
      end

      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}/comments" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{commented_recipes[79].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[80].id}"
        expect(response.body).to include "/recipes/#{commented_recipes[119].id}"
        expect(response.body).not_to include "/recipes/#{commented_recipes[120].id}"
        expect(response.body).not_to include "/recipes/#{not_commented_recipe.id}"
      end
    end
  end

  describe 'users#favorites' do
    let(:alice) { create(:user, :no_image, username: 'alice') }
    let(:favored_recipes) { alice.favored_recipes.order('favorites.id desc') }
    let(:not_favored_recipe) { (Recipe.all - favored_recipes).first }

    context 'when 40 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 28, :no_image, user: user) }
        random_recipes = Recipe.all.sample(81)
        random_recipes.each { |recipe| alice.favorites.create(recipe_id: recipe.id) }
      end

      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}/favorites" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{favored_recipes[39].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[40].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[79].id}"
        expect(response.body).not_to include "/recipes/#{favored_recipes[80].id}"
        expect(response.body).not_to include "/recipes/#{not_favored_recipe.id}"
      end
    end

    context 'when 80 items are already displayed' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 41, :no_image, user: user) }
        random_recipes = Recipe.all.sample(121)
        random_recipes.each { |recipe| alice.favorites.create(recipe_id: recipe.id) }
      end

      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}/favorites" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/recipes/#{favored_recipes[79].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[80].id}"
        expect(response.body).to include "/recipes/#{favored_recipes[119].id}"
        expect(response.body).not_to include "/recipes/#{favored_recipes[120].id}"
        expect(response.body).not_to include "/recipes/#{not_favored_recipe.id}"
      end
    end
  end

  describe 'users#followers' do
    let(:alice) { create(:user, :no_image) }
    let(:followers) { alice.followers.order('relationships.id desc') }
    let(:not_follower) { (User.all - [alice] - followers).first }

    context 'when 40 items are already displayed' do
      before do
        create_list(:user, 82, :no_image)
        random_users = User.all.sample(81)
        random_users.each { |user| user.relationships.create(follow_id: alice.id) }
      end

      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}/followers" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/users/#{followers[39].username}"
        expect(response.body).to include "/users/#{followers[40].username}"
        expect(response.body).to include "/users/#{followers[79].username}"
        expect(response.body).not_to include "/users/#{followers[80].username}"
        expect(response.body).not_to include "/users/#{not_follower.username}"
      end
    end

    context 'when 80 items are already displayed' do
      before do
        create_list(:user, 122, :no_image)
        random_users = User.all.sample(121)
        random_users.each { |user| user.relationships.create(follow_id: alice.id) }
      end

      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}/followers" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/users/#{followers[79].username}"
        expect(response.body).to include "/users/#{followers[80].username}"
        expect(response.body).to include "/users/#{followers[119].username}"
        expect(response.body).not_to include "/users/#{followers[120].username}"
        expect(response.body).not_to include "/users/#{not_follower.username}"
      end
    end
  end

  describe 'users#followings' do
    let(:alice) { create(:user, :no_image, username: 'alice') }
    let(:followings) { alice.followings.order('relationships.id desc') }
    let(:not_following) { (User.all - [alice] - followings).first }

    context 'when 40 items are already displayed' do
      before do
        create_list(:user, 82, :no_image)
        random_users = User.all.sample(81)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
      end

      let(:params) { { displayed_item_count: '40', path: "users/#{alice.username}/followings" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/users/#{followings[39].username}"
        expect(response.body).to include "/users/#{followings[40].username}"
        expect(response.body).to include "/users/#{followings[79].username}"
        expect(response.body).not_to include "/users/#{followings[80].username}"
        expect(response.body).not_to include "/users/#{not_following.username}"
      end
    end

    context 'when 80 items are already displayed' do
      before do
        create_list(:user, 122, :no_image)
        random_users = User.all.sample(121)
        random_users.each { |user| alice.relationships.create(follow_id: user.id) }
      end

      let(:params) { { displayed_item_count: '80', path: "users/#{alice.username}/followings" } }

      it 'returns a 200 response' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct links' do
        get infinite_scroll_path, params: params, xhr: true
        expect(response.body).not_to include "/users/#{followings[79].username}"
        expect(response.body).to include "/users/#{followings[80].username}"
        expect(response.body).to include "/users/#{followings[119].username}"
        expect(response.body).not_to include "/users/#{followings[120].username}"
        expect(response.body).not_to include "/users/#{not_following.username}"
      end
    end
  end
end
