require 'rails_helper'

RSpec.describe 'Search', type: :system do
  before do
    alice = create(:user, nickname: 'アリス', profile: '味噌ラーメンが好き')
    create(:user, nickname: 'ボブ', profile: 'しょうゆらーめんが好き')
    create(:user, nickname: 'キャロル', profile: '塩らーめんが好き')
    create(:user, nickname: 'dave', profile: 'I like tonkotsu ramen')

    create(:recipe, :with_images, images_count: 1, title: '味噌ラーメン', body: '味噌らーめんの作り方', tag_list: 'ラーメン', user: alice)
    create(:recipe, :with_images, images_count: 1, title: 'しょうゆラーメン', body: 'しょうゆラーメンの作り方', user: alice)
    create(:recipe, :with_images, images_count: 1, title: '塩ラーメン', body: '塩ラーメンの作り方', tag_list: 'ラーメン', user: alice)
    create(:recipe, :with_images, images_count: 1, title: 'とんこつ', body: 'とんこつらーめんの作り方', tag_list: 'らーめん', user: alice)
  end

  it 'keeps keyword and search source', js: true do
    visit root_path
    fill_in 'q', with: 'ラーメン'
    find_by_id('q').send_keys :enter
    expect(page).to have_css '[data-rspec=recipe_title_results]'
    expect(find_by_id('q').value).to eq 'ラーメン'

    within '[data-rspec=search-menu]' do
      click_link 'プロフィール'
    end
    expect(page).to have_css '[data-rspec=user_profile_results]'
    expect(find_by_id('q').value).to eq 'ラーメン'

    fill_in 'q', with: 'らーめん'
    find_by_id('q').send_keys :enter
    expect(page).to have_css '[data-rspec=user_profile_results]'
    expect(find_by_id('q').value).to eq 'らーめん'
  end
end
