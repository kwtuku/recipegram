require 'rails_helper'

RSpec.describe 'Notifications', type: :system do
  let(:alice) { create :user, :no_image }
  let(:bob) { create :user, :no_image }
  let(:alice_recipe) { create :recipe, :no_image, user: alice }

  describe 'comment notification' do
    let!(:bob_comment) { create :comment, user: bob, recipe: alice_recipe }
    let(:carol) { create :user, :no_image }
    let!(:carol_comment) { create :comment, user: carol, recipe: alice_recipe }

    context 'comment user != recipe user' do
      let(:dave) { create :user, :no_image }
      before do
        sign_in dave
        visit recipe_path(alice_recipe)
        fill_in 'comment[body]', with: 'いいレシピですね！'
        expect{
          click_button 'create_comment'
        }.to change { alice_recipe.comments.count }.by(1)
        .and change { alice.notifications.count }.by(1)
        .and change { bob.notifications.count }.by(1)
        .and change { carol.notifications.count }.by(1)
        .and change { dave.notifications.count }.by(0)
        sign_out
      end

      it 'creates comment notification for recipe user', js: true do
        sign_in alice
        expect(page).to have_css '.has-unchecked-notification'
        click_link href: notifications_path
        comment = Comment.find_by(user_id: dave.id, recipe_id: alice_recipe.id)
        expect(page).to  have_link "#{comment.user.nickname}"
        expect(page).to  have_content 'さんが'
        expect(page).to  have_link "あなたの投稿「#{alice_recipe.title}」"
        expect(page).to  have_content 'にコメントしました。'
      end

      it 'creates comment notification for other comment user', js: true do
        sign_in bob
        expect(page).to have_css '.has-unchecked-notification'
        click_link href: notifications_path
        comment = Comment.find_by(user_id: dave.id, recipe_id: alice_recipe.id)
        expect(page).to  have_link "#{comment.user.nickname}"
        expect(page).to  have_content 'さんが'
        expect(page).to  have_link "あなたがコメントした投稿「#{alice_recipe.title}」"
        expect(page).to  have_content 'にコメントしました。'
      end

      it 'does not create comment notification for comment user', js: true do
        sign_in dave
        expect(page).to have_no_css '.has-unchecked-notification'
      end
    end

    context 'comment user == recipe user' do
      before do
        sign_in alice
        visit recipe_path(alice_recipe)
        fill_in 'comment[body]', with: 'いいレシピですね！'
        expect{
          click_button 'create_comment'
        }.to change { alice_recipe.comments.count }.by(1)
        .and change { alice.notifications.count }.by(0)
        .and change { bob.notifications.count }.by(1)
        .and change { carol.notifications.count }.by(1)
        sign_out
      end

      it 'does not create comment notification for recipe user', js: true do
        sign_in alice
        expect(page).to have_no_css '.has-unchecked-notification'
      end

      it 'creates comment notification for other comment user', js: true do
        sign_in bob
        expect(page).to have_css '.has-unchecked-notification'
        click_link href: notifications_path
        comment = Comment.find_by(user_id: alice.id, recipe_id: alice_recipe.id)
        expect(page).to  have_link "#{comment.user.nickname}"
        expect(page).to  have_content 'さんが'
        expect(page).to  have_link "あなたがコメントした投稿「#{alice_recipe.title}」"
        expect(page).to  have_content 'にコメントしました。'
      end
    end
  end

  describe 'favorite notification' do
    it 'creates favorite notification when user makes a favorite on the recipe other user created', js: true do
      sign_in bob
      visit recipe_path(alice_recipe)
      click_link href: recipe_favorites_path(alice_recipe)
      expect(page).to have_selector '.rspec_destroy_favorite'
      expect(alice_recipe.favorites.count).to eq 1
      expect(alice.notifications.count).to eq 1
      sign_out

      sign_in alice
      click_link href: notifications_path
      favorite = Favorite.find_by(user_id: bob.id, recipe_id: alice_recipe.id)
      expect(page).to  have_link "#{favorite.user.nickname}"
      expect(page).to  have_content 'さんが'
      expect(page).to  have_link "あなたの投稿「#{favorite.recipe.title}」"
      expect(page).to  have_content 'にいいねしました。'
    end

    it 'does not create favorite notification when user makes a favorite on own recipe', js: true do
      sign_in alice
      visit recipe_path(alice_recipe)
      click_link href: recipe_favorites_path(alice_recipe)
      expect(page).to have_selector '.rspec_destroy_favorite'
      expect(alice_recipe.favorites.count).to eq 1
      expect(alice.notifications.count).to eq 0
    end
  end

  describe 'relationship notification' do
    it 'creates relationship notification', js: true do
      sign_in bob
      visit user_path(alice)
      click_button 'フォロー'
      expect(page).to have_button 'フォロー解除'
      expect(alice.followers.count).to eq 1
      expect(alice.notifications.count).to eq 1
      sign_out

      sign_in alice
      click_link href: notifications_path
      relationship = Relationship.find_by(user_id: bob.id, follow_id: alice.id)
      expect(page).to  have_link "#{relationship.user.nickname}"
      expect(page).to  have_content 'さんが'
      expect(page).to  have_content 'あなたをフォローしました。'
    end
  end
end
