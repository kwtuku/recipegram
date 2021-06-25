require 'rails_helper'

RSpec.describe 'Search', type: :system do
  let!(:kotteri_miso_ramen) { create :recipe, title: 'こってり味噌ラーメン' }
  let!(:kotteri_shio_ramen) { create :recipe, title: 'こってり塩ラーメン' }
  let!(:kotteri_shoyu_ramen) { create :recipe, title: 'こってりしょうゆラーメン' }
  let!(:kotteri_tonkotsu_ramen) { create :recipe, title: 'こってり豚骨ラーメン' }
  let!(:sappari_miso_ramen) { create :recipe, title: 'さっぱり味噌ラーメン' }
  let!(:sappari_shio_ramen) { create :recipe, title: 'さっぱり塩ラーメン' }
  let!(:sappari_shoyu_ramen) { create :recipe, title: 'さっぱりしょうゆラーメン' }
  let!(:sappari_tonkotsu_ramen) { create :recipe, title: 'さっぱり豚骨ラーメン' }

  it 'returns no result', js: true do
    visit root_path
    click_link href: search_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: 'ごはん'
    click_button 'search'
    expect(page).to have_content '「ごはん」は見つかりませんでした。'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '0'
  end
  it 'returns result from recipe titles', js: true do
    visit root_path
    click_link href: search_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: '味噌'
    click_button 'search'
    expect(page).to have_link 'こってり味噌ラーメン'
    expect(page).to have_link 'さっぱり味噌ラーメン'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '2'
  end
  it 'and search using space', js: true do
    visit root_path
    click_link href: search_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: 'こってり ラーメン'
    click_button 'search'
    expect(page).to have_link 'こってり味噌ラーメン'
    expect(page).to have_link 'こってり塩ラーメン'
    expect(page).to have_link 'こってりしょうゆラーメン'
    expect(page).to have_link 'こってり豚骨ラーメン'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '4'
  end
  it 'and search using zenkaku spece', js: true do
    visit root_path
    click_link href: search_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: 'こってり　ラーメン'
    click_button 'search'
    expect(page).to have_link 'こってり味噌ラーメン'
    expect(page).to have_link 'こってり塩ラーメン'
    expect(page).to have_link 'こってりしょうゆラーメン'
    expect(page).to have_link 'こってり豚骨ラーメン'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '4'
  end
end
