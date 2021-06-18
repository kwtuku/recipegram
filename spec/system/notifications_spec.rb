require 'rails_helper'

RSpec.describe 'Notifications', type: :system do
  let(:user) { create :user,  :with_recipes }
  let(:other_user) { create :user }
  let(:user_recipe) { user.recipes[0] }

  it 'favorite notification', js: true do
    user_recipe.create_favorite_notification!(other_user)
    notification = user.passive_notifications[0]
    expect(notification.checked?).to eq false
    sign_in user
    expect(page).to have_css '.has-unchecked-notification'
    click_link href: notifications_path
    expect(current_path).to eq notifications_path
    expect(page).to  have_link "#{notification.visitor.username}"
    expect(page).to  have_content 'さんが'
    expect(page).to  have_link "あなたの投稿「#{notification.recipe.title}」"
    expect(page).to  have_content 'にいいねしました。'
    expect(notification.reload.checked?).to eq true
  end
end
