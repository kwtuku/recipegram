require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let(:user) { create :user }
  let(:other_user) { create :user }

  it 'follow', js: true do
    sign_in user
    visit user_path(other_user)
    click_button 'フォロー'
    expect(page).to have_button 'フォロー解除'
    find('.recipegram').hover
    expect(page).to have_button 'フォロー中'
    expect(other_user.followers.count).to eq 1
  end
  it 'unfollow', js: true do
    user.relationships.create!(follow_id: other_user.id)
    expect(other_user.followers.count).to eq 1
    sign_in user
    visit user_path(other_user)
    find_button('フォロー中').hover
    click_button 'フォロー解除'
    page.accept_confirm
    expect(page).to have_button 'フォロー'
    expect(other_user.favorites.count).to eq 0
  end
end
