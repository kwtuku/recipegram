require 'rails_helper'

RSpec.describe 'InfiniteScroll', type: :system do
  describe 'home#home' do
    context 'when not signed in' do
      before do
        users = create_list(:user, 3, :no_image)
        users.each { |user| create_list(:recipe, 12, :no_image, user: user) }
      end

      it 'can infinite scroll', js: true do
        visit root_path
        expect(all('[data-rspec^=recipe-]').size).to eq 20
        expect(page).to have_css '#remove-after-loading'

        execute_script('window.scrollBy(0,100000)')
        expect(page).to have_css '[data-rspec=inserted-loading-animation]'
        expect(all('[data-rspec^=recipe-]').size).to eq 40
      end
    end

    context 'when signed in' do
      let(:alice) { create :user, :no_image }
      let(:feeds) { alice.feed.order(updated_at: :DESC) }

      before do
        users = create_list(:user, 3, :no_image)
        users.each do |user|
          create_list(:recipe, 15, :no_image, user: user, updated_at: rand(1..100).minutes.ago)
        end
        User.all.each { |user| alice.relationships.create(follow_id: user.id) }
        create_list(:recipe, 16, :no_image, user: alice, updated_at: rand(1..100).minutes.ago)
      end

      it 'can infinite scroll', js: true do
        sign_in alice
        visit root_path
        expect(page).to have_css "[data-rspec=recipe-#{feeds[19].id}]"
        expect(page).not_to have_css "[data-rspec=recipe-#{feeds[20].id}]"

        execute_script('window.scrollBy(0,100000)')
        expect(page).to have_css "[data-rspec=recipe-#{feeds[20].id}]"
        expect(page).to have_css "[data-rspec=recipe-#{feeds[39].id}]"
        expect(page).not_to have_css "[data-rspec=recipe-#{feeds[40].id}]"

        execute_script('window.scrollBy(0,100000)')
        expect(page).to have_css "[data-rspec=recipe-#{feeds[40].id}]"
        expect(page).to have_css "[data-rspec=recipe-#{feeds[59].id}]"
        expect(page).not_to have_css "[data-rspec=recipe-#{feeds[60].id}]"
      end
    end
  end

  describe 'recipes#index' do
    let(:recipes) { Recipe.order(updated_at: :DESC) }

    before do
      users = create_list(:user, 3, :no_image)
      users.each { |user| create_list(:recipe, 41, :no_image, user: user) }
    end

    it 'can infinite scroll', js: true do
      visit recipes_path
      expect(page).to have_css "[data-rspec=recipe-#{recipes[39].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{recipes[40].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{recipes[40].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{recipes[79].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{recipes[80].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{recipes[80].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{recipes[119].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{recipes[120].id}]"
    end
  end

  describe 'tags#show' do
    let(:tagged_recipes) { Recipe.tagged_with('かんたん').order(id: :DESC) }

    before do
      users = create_list(:user, 3, :no_image)
      users.each { |user| create_list(:recipe, 41, :no_image, user: user, tag_list: 'かんたん') }
    end

    it 'can infinite scroll', js: true do
      tag = Tag.find_by(name: 'かんたん')
      visit tag_path(tag.name)
      expect(page).to have_css "[data-rspec=recipe-#{tagged_recipes[39].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{tagged_recipes[40].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{tagged_recipes[40].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{tagged_recipes[79].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{tagged_recipes[80].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{tagged_recipes[80].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{tagged_recipes[119].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{tagged_recipes[120].id}]"
    end
  end

  describe 'users#index' do
    let(:users) { User.order(id: :DESC) }

    before { create_list(:user, 121, :no_image) }

    it 'can infinite scroll', js: true do
      visit users_path
      expect(page).to have_css "[data-rspec=user-#{users[39].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{users[40].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=user-#{users[40].id}]"
      expect(page).to have_css "[data-rspec=user-#{users[79].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{users[80].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=user-#{users[80].id}]"
      expect(page).to have_css "[data-rspec=user-#{users[119].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{users[120].id}]"
    end
  end

  describe 'users#show' do
    let(:alice) { create :user, :no_image }
    let(:posted_recipes) { alice.recipes.order(id: :DESC) }
    let(:not_posted_recipe) { create :recipe, :no_image }

    before { create_list(:recipe, 121, :no_image, user: alice) }

    it 'can infinite scroll', js: true do
      visit user_path(alice)
      expect(page).to have_css "[data-rspec=recipe-#{posted_recipes[39].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{posted_recipes[40].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{posted_recipes[40].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{posted_recipes[79].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{posted_recipes[80].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{posted_recipes[80].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{posted_recipes[119].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{posted_recipes[120].id}]"
    end
  end

  describe 'users#comments' do
    let(:alice) { create :user, :no_image }
    let(:commented_recipes) { alice.commented_recipes.order('comments.created_at desc') }
    let(:not_commented_recipe) { (Recipe.all - commented_recipes).first }

    before do
      users = create_list(:user, 3, :no_image)
      users.each { |user| create_list(:recipe, 41, :no_image, user: user) }
      random_recipes = Recipe.all.sample(121)
      random_recipes.each { |recipe| create :comment, user: alice, recipe: recipe }
    end

    it 'can infinite scroll', js: true do
      sign_in alice
      visit user_comments_path(alice)
      expect(page).to have_css "[data-rspec=recipe-#{commented_recipes[39].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{commented_recipes[40].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{commented_recipes[40].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{commented_recipes[79].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{commented_recipes[80].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{commented_recipes[80].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{commented_recipes[119].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{commented_recipes[120].id}]"
    end
  end

  describe 'users#favorites' do
    let(:alice) { create :user, :no_image }
    let(:favored_recipes) { alice.favored_recipes.order('favorites.created_at desc') }
    let(:not_favored_recipe) { (Recipe.all - favored_recipes).first }

    before do
      users = create_list(:user, 3, :no_image)
      users.each { |user| create_list(:recipe, 41, :no_image, user: user) }
      random_recipes = Recipe.all.sample(121)
      random_recipes.each { |recipe| alice.favorites.create(recipe_id: recipe.id) }
    end

    it 'can infinite scroll', js: true do
      sign_in alice
      visit user_favorites_path(alice)
      expect(page).to have_css "[data-rspec=recipe-#{favored_recipes[39].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{favored_recipes[40].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{favored_recipes[40].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{favored_recipes[79].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{favored_recipes[80].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=recipe-#{favored_recipes[80].id}]"
      expect(page).to have_css "[data-rspec=recipe-#{favored_recipes[119].id}]"
      expect(page).not_to have_css "[data-rspec=recipe-#{favored_recipes[120].id}]"
    end
  end

  describe 'users#followers' do
    let(:alice) { create :user, :no_image }
    let(:followers) { alice.followers.order('relationships.created_at desc') }
    let(:not_follower) { (User.all - [alice] - followers).first }

    before do
      create_list(:user, 122, :no_image)
      random_users = User.all.sample(121)
      random_users.each { |user| user.relationships.create(follow_id: alice.id) }
    end

    it 'can infinite scroll', js: true do
      sign_in alice
      visit user_followers_path(alice)
      expect(page).to have_css "[data-rspec=user-#{followers[39].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{followers[40].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=user-#{followers[40].id}]"
      expect(page).to have_css "[data-rspec=user-#{followers[79].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{followers[80].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=user-#{followers[80].id}]"
      expect(page).to have_css "[data-rspec=user-#{followers[119].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{followers[120].id}]"
    end
  end

  describe 'users#followings' do
    let(:alice) { create :user, :no_image, username: 'alice' }
    let(:followings) { alice.followings.order('relationships.created_at desc') }
    let(:not_following) { (User.all - [alice] - followings).first }

    before do
      create_list(:user, 122, :no_image)
      random_users = User.all.sample(121)
      random_users.each { |user| alice.relationships.create(follow_id: user.id) }
    end

    it 'can infinite scroll', js: true do
      sign_in alice
      visit user_followings_path(alice)
      expect(page).to have_css "[data-rspec=user-#{followings[39].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{followings[40].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=user-#{followings[40].id}]"
      expect(page).to have_css "[data-rspec=user-#{followings[79].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{followings[80].id}]"

      execute_script('window.scrollBy(0,100000)')
      expect(page).to have_css "[data-rspec=user-#{followings[80].id}]"
      expect(page).to have_css "[data-rspec=user-#{followings[119].id}]"
      expect(page).not_to have_css "[data-rspec=user-#{followings[120].id}]"
    end
  end
end