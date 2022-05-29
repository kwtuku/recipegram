require 'rails_helper'

RSpec.describe 'InfiniteScroll', type: :system do
  describe 'home#home' do
    context 'when not signed in' do
      it 'works', js: true do
        create_list(:user, 3).each { |user| create_list(:recipe, 14, :with_images, images_count: 1, user: user) }

        visit root_path
        expect(all('[data-rspec^=recipe-]').size).to eq 20

        execute_script('window.scrollBy(0,100000)')
        expect(page).to have_css '[data-rspec=done]'
        expect(all('[data-rspec^=recipe-]').size).to eq 40
      end
    end

    context 'when signed in' do
      it 'works', js: true do
        alice = create(:user)
        create_list(:user, 3).each do |user|
          create_list(:recipe, 15, :with_images, images_count: 1, user: user)
          alice.relationships.create(follow_id: user.id)
        end
        create_list(:recipe, 16, :with_images, images_count: 1, user: alice)
        feed = alice.feed.order(id: :desc)

        sign_in alice
        visit root_path
        expect(page).to have_css "[data-rspec=recipe-#{feed[19].id}]"
        expect(page).not_to have_css "[data-rspec=recipe-#{feed[20].id}]"

        execute_script('window.scrollBy(0,100000)')
        expect(page).to have_css "[data-rspec=recipe-#{feed[20].id}]"
        expect(page).to have_css "[data-rspec=recipe-#{feed[39].id}]"
        expect(page).not_to have_css "[data-rspec=recipe-#{feed[40].id}]"

        execute_script('window.scrollBy(0,100000)')
        expect(page).to have_css "[data-rspec=recipe-#{feed[40].id}]"
        expect(page).to have_css "[data-rspec=recipe-#{feed[59].id}]"
        expect(page).not_to have_css "[data-rspec=recipe-#{feed[60].id}]"
      end
    end
  end

  describe 'recipes#index' do
    it 'works', js: true do
      create_list(:user, 3).each { |user| create_list(:recipe, 41, :with_images, images_count: 1, user: user) }
      recipes = Recipe.order(id: :desc)

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
    it 'works', js: true do
      users = create_list(:user, 3)
      users.each { |user| create_list(:recipe, 41, :with_images, images_count: 1, user: user, tag_list: 'かんたん') }
      tagged_recipes = Recipe.tagged_with('かんたん').order(id: :desc)

      visit tag_path('かんたん')
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
    it 'works', js: true do
      create_list(:user, 121)
      users = User.order(id: :desc)

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
    it 'works', js: true do
      alice = create(:user)
      create_list(:recipe, 121, :with_images, images_count: 1, user: alice)
      posted_recipes = alice.recipes.order(id: :desc)

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
    it 'works', js: true do
      alice = create(:user)
      create_list(:user, 3).each { |user| create_list(:recipe, 41, :with_images, images_count: 1, user: user) }
      Recipe.all.sample(121).each { |recipe| create(:comment, user: alice, recipe: recipe) }
      commented_recipes = alice.commented_recipes.order('comments.id desc')

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
    it 'works', js: true do
      alice = create(:user)
      create_list(:user, 3).each { |user| create_list(:recipe, 41, :with_images, images_count: 1, user: user) }
      Recipe.all.sample(121).each { |recipe| alice.favorites.create(recipe_id: recipe.id) }
      favored_recipes = alice.favored_recipes.order('favorites.id desc')

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
    it 'works', js: true do
      alice = create(:user)
      create_list(:user, 122)
      User.all.sample(121).each { |user| user.relationships.create(follow_id: alice.id) }
      followers = alice.followers.order('relationships.id desc')

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
    it 'works', js: true do
      alice = create(:user)
      create_list(:user, 122)
      User.all.sample(121).each { |user| alice.relationships.create(follow_id: user.id) }
      followings = alice.followings.order('relationships.id desc')

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
