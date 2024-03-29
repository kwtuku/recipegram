require 'rails_helper'

RSpec.describe 'Tags::followers', type: :system do
  let(:alice) { create(:user) }
  let(:tag) { create(:tag) }

  before { create(:recipe, :with_images, images_count: 1, tag_list: tag.name) }

  it 'follows a tag', js: true do
    expect(TagFollowing.count).to eq 0
    sign_in alice
    visit tag_path(tag.name)
    click_button 'フォロー'
    expect(page).to have_button 'フォロー解除'
    find('.recipegram').hover
    expect(page).to have_button 'フォロー中'
    expect(TagFollowing.count).to eq 1
  end

  it 'unfollows a tag', js: true do
    alice.tag_followings.create!(tag_id: tag.id)
    expect(TagFollowing.count).to eq 1
    sign_in alice
    visit tag_path(tag.name)
    find_button('フォロー中').hover
    click_button 'フォロー解除'
    page.accept_confirm
    expect(page).to have_button 'フォロー'
    expect(TagFollowing.count).to eq 0
  end
end
