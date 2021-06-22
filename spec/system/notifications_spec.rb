require 'rails_helper'

RSpec.describe 'Notifications', type: :system do
  let(:user) { create :user,  :with_recipes }
  let(:other_user) { create :user }
  let(:user_recipe) { user.recipes[0] }
  let(:other_user_recipe) { create :recipe, user: other_user }

  context 'other_user makes a comment on the recipe user created' do
    let(:other_user_comment) { create :comment, user: other_user, recipe: user_recipe }

    it 'create comment notification', js: true do
      sign_in user
      expect(page).to have_no_css '.has-unchecked-notification'
      other_user_comment.create_comment_notification!(other_user, other_user_comment.id, user_recipe.id)
      notification = user.passive_notifications[0]
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
  context 'other_user makes a comment on the recipe user made a comment' do
    let(:other_user_comment) { create :comment, user: other_user, recipe: other_user_recipe }

    it 'create comment notification', js: true do
      sign_in user
      expect(page).to have_no_css '.has-unchecked-notification'
      user.comments.create!(recipe_id: other_user_recipe.id, body: 'いいね！')
      other_user_comment.create_comment_notification!(other_user, other_user_comment.id, other_user_recipe.id)
      notification = user.passive_notifications[0]
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
  it 'create favorite notification', js: true do
    sign_in user
    expect(page).to have_no_css '.has-unchecked-notification'
    user_recipe.create_favorite_notification!(other_user)
    notification = user.passive_notifications[0]
    expect(notification.checked?).to eq false
    visit current_path
    expect(page).to have_css '.has-unchecked-notification'
    click_link href: notifications_path
    expect(current_path).to eq notifications_path
    expect(page).to  have_link "#{notification.visitor.username}"
    expect(page).to  have_content 'さんが'
    expect(page).to  have_link "あなたの投稿「#{notification.recipe.title}」"
    expect(page).to  have_content 'にいいねしました。'
    expect(notification.reload.checked?).to eq true
  end
  it 'create follow notification', js: true do
    sign_in user
    expect(page).to have_no_css '.has-unchecked-notification'
    user.create_follow_notification!(other_user)
    notification = user.passive_notifications[0]
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
