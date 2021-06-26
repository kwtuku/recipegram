require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let(:alice) { create :user }
  let(:bob) { create :user }

  it 'follow', js: true do
    sign_in alice
    visit user_path(bob)
    click_button 'フォロー'
    expect(page).to have_button 'フォロー解除'
    find('.recipegram').hover
    expect(page).to have_button 'フォロー中'
    expect(bob.followers.count).to eq 1
  end
  it 'unfollow', js: true do
    alice.relationships.create!(follow_id: bob.id)
    expect(bob.followers.count).to eq 1
    sign_in alice
    visit user_path(bob)
    find_button('フォロー中').hover
    click_button 'フォロー解除'
    page.accept_confirm
    expect(page).to have_button 'フォロー'
    expect(bob.favorites.count).to eq 0
  end
end
