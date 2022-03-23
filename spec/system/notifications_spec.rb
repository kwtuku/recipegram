require 'rails_helper'

RSpec.describe 'Notifications', type: :system do
  let(:alice) { create(:user, :no_image) }
  let(:bob) { create(:user, :no_image) }
  let(:alice_recipe) { create(:recipe, :with_images, images_count: 1, user: alice) }

  describe 'comment notification' do
    before { create(:comment, user: bob, recipe: alice_recipe) }

    context 'when comment user is not recipe user' do
      let(:carol) { create(:user, :no_image) }

      before do
        sign_in carol
        visit recipe_path(alice_recipe)
        fill_in 'comment[body]', with: 'いいレシピですね！'
      end

      it 'creates recipe user notification', js: true do
        expect do
          click_button 'create_comment'
        end.to change(alice.notifications, :count).by(1)

        sign_out
        sign_in alice
        expect(page).to have_css '.has-unchecked-notification'
        click_link href: notifications_path
        comment = Comment.find_by(user_id: carol.id, recipe_id: alice_recipe.id)
        expect(page).to have_link comment.user.nickname
        expect(page).to have_link "あなたの投稿「#{alice_recipe.title}」"
        expect(page).to have_content 'にコメントしました。'
      end

      it 'creates other comment user notification', js: true do
        expect do
          click_button 'create_comment'
        end.to change(bob.notifications, :count).by(1)

        sign_out
        sign_in bob
        expect(page).to have_css '.has-unchecked-notification'
        click_link href: notifications_path
        comment = Comment.find_by(user_id: carol.id, recipe_id: alice_recipe.id)
        expect(page).to have_link comment.user.nickname
        expect(page).to have_link "あなたがコメントした投稿「#{alice_recipe.title}」"
        expect(page).to have_content 'にコメントしました。'
      end

      it 'does not create comment user notification', js: true do
        expect do
          click_button 'create_comment'
        end.to change(carol.notifications, :count).by(0)
        expect(page).to have_no_css '.has-unchecked-notification'
      end
    end

    context 'when comment user is recipe user' do
      before do
        sign_in alice
        visit recipe_path(alice_recipe)
        fill_in 'comment[body]', with: 'いいレシピですね！'
      end

      it 'does not create recipe user notification', js: true do
        expect do
          click_button 'create_comment'
        end.to change(alice.notifications, :count).by(0)
        expect(page).to have_no_css '.has-unchecked-notification'
      end

      it 'creates other comment user notification', js: true do
        expect do
          click_button 'create_comment'
        end.to change(bob.notifications, :count).by(1)

        sign_out
        sign_in bob
        expect(page).to have_css '.has-unchecked-notification'
        click_link href: notifications_path
        comment = Comment.find_by(user_id: alice.id, recipe_id: alice_recipe.id)
        expect(page).to have_link comment.user.nickname
        expect(page).to have_link "あなたがコメントした投稿「#{alice_recipe.title}」"
        expect(page).to have_content 'にコメントしました。'
      end
    end
  end

  describe 'favorite notification' do
    context 'when user makes a favorite on other user recipe' do
      it 'creates a notification of recipe user', js: true do
        expect(alice.notifications.count).to eq 0
        sign_in bob
        visit recipe_path(alice_recipe)
        click_link href: recipe_favorites_path(alice_recipe)
        expect(page).to have_selector '.rspec_destroy_favorite'
        expect(alice.notifications.count).to eq 1

        sign_out
        sign_in alice
        click_link href: notifications_path
        favorite = Favorite.find_by(user_id: bob.id, recipe_id: alice_recipe.id)
        expect(page).to have_link favorite.user.nickname
        expect(page).to have_link "あなたの投稿「#{favorite.recipe.title}」"
        expect(page).to have_content 'にいいねしました。'
      end
    end

    context 'when user makes a favorite on own recipe' do
      it 'does not create Notification', js: true do
        expect(Notification.count).to eq 0
        sign_in alice
        visit recipe_path(alice_recipe)
        click_link href: recipe_favorites_path(alice_recipe)
        expect(page).to have_selector '.rspec_destroy_favorite'
        expect(Notification.count).to eq 0
      end
    end
  end

  describe 'relationship notification' do
    it 'creates a notification of followed user', js: true do
      expect(alice.notifications.count).to eq 0
      sign_in bob
      visit user_path(alice)
      click_button 'フォロー'
      expect(page).to have_button 'フォロー解除'
      expect(alice.notifications.count).to eq 1

      sign_out
      sign_in alice
      click_link href: notifications_path
      relationship = Relationship.find_by(user_id: bob.id, follow_id: alice.id)
      expect(page).to have_link relationship.user.nickname
      expect(page).to have_content 'あなたをフォローしました。'
    end
  end
end
