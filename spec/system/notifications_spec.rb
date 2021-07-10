require 'rails_helper'

RSpec.describe 'Notifications', type: :system do
  let(:alice) { create :user }
  let(:bob) { create :user }
  let(:alice_recipe) { create :recipe, user: alice }
  let(:bob_recipe) { create :recipe, user: bob }

  context 'bob makes a comment on the recipe alice created' do
    let(:bob_comment) { create :comment, user: bob, recipe: alice_recipe }

    it 'create comment notification', js: true do
      sign_in alice
      expect(page).to have_no_css '.has-unchecked-notification'
      bob_comment.create_comment_notification!(bob, bob_comment.id, alice_recipe.id)
      notification = alice.passive_notifications[0]
      expect(notification.checked?).to eq false
      visit current_path
      expect(page).to have_css '.has-unchecked-notification'
      click_link href: notifications_path
      expect(current_path).to eq notifications_path
      expect(page).to  have_link "#{notification.visitor.username}"
      expect(page).to  have_content 'さんが'
      expect(page).to  have_link "あなたの投稿「#{notification.recipe.title}」"
      expect(page).to  have_content 'にコメントしました。'
      expect(notification.reload.checked?).to eq true
    end
  end
  context 'bob makes a comment on the recipe alice made a comment on' do
    let(:bob_comment) { create :comment, user: bob, recipe: bob_recipe }

    it 'create comment notification', js: true do
      sign_in alice
      expect(page).to have_no_css '.has-unchecked-notification'
      alice.comments.create!(recipe_id: bob_recipe.id, body: 'いいね！')
      bob_comment.create_comment_notification!(bob, bob_comment.id, bob_recipe.id)
      notification = alice.passive_notifications[0]
      expect(notification.checked?).to eq false
      visit current_path
      expect(page).to have_css '.has-unchecked-notification'
      click_link href: notifications_path
      expect(current_path).to eq notifications_path
      expect(page).to  have_link "#{notification.visitor.username}"
      expect(page).to  have_content 'さんが'
      expect(page).to  have_link "あなたがコメントした投稿「#{notification.comment.recipe.title}」"
      expect(page).to  have_content 'にコメントしました。'
      expect(notification.reload.checked?).to eq true
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
      sign_out bob

      sign_in alice
      click_link href: notifications_path
      favorite = Favorite.find_by(user_id: bob.id, recipe_id: alice_recipe.id)
      expect(page).to  have_link "#{favorite.user.username}"
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

  it 'create follow notification', js: true do
    sign_in alice
    expect(page).to have_no_css '.has-unchecked-notification'
    alice.create_follow_notification!(bob)
    notification = alice.passive_notifications[0]
    expect(notification.checked?).to eq false
    visit current_path
    expect(page).to have_css '.has-unchecked-notification'
    click_link href: notifications_path
    expect(current_path).to eq notifications_path
    expect(page).to  have_link "#{notification.visitor.username}"
    expect(page).to  have_content 'さんが'
    expect(page).to  have_content 'あなたをフォローしました。'
    expect(notification.reload.checked?).to eq true
  end
end
