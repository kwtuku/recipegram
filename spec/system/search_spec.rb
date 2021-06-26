require 'rails_helper'

RSpec.describe 'Search', type: :system do
  let!(:miso_ramen) { create :recipe, title: '味噌ラーメンの作り方', body: '味噌ラーメンの作り方です。' }
  let!(:miso_soup) { create :recipe, title: '味噌汁', body: '味噌汁の作り方です。' }
  let!(:miso_katsudon) { create :recipe, title: '味噌カツ丼', body: '味噌カツ丼の作り方です。' }
  let!(:miso_udon) { create :recipe, title: '味噌煮込みうどん', body: '味噌煮込みうどんの作り方です。' }
  let!(:miso) { create :recipe, title: '味噌', body: 'みその作り方です。' }
  let!(:tonkotsu_ramen) { create :recipe, title: '豚骨ラーメン', body: '豚骨ラーメンの作り方です。' }

  let!(:miso_ramen_man) { create :user, username: '味噌ラーメン大好きマン', profile: '味噌ラーメン大好き' }
  let!(:alice) { create :user, username: 'アリス', profile: '味噌ラーメンの作り方知ってます。' }
  let!(:bob) { create :user, username: 'ボブ', profile: '味噌カツ丼の作り方知りたい！' }
  let!(:carol) { create :user, username: '味噌好きキャロル', profile: 'みそ汁が作れます。' }
  let!(:dave) { create :user, username: 'dave', profile: 'I am dave.' }

  it 'returns no result', js: true do
    visit root_path
    click_link href: search_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: 'ごはん'
    click_button 'search'
    expect(page).to have_content '「ごはん」は見つかりませんでした。'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '0'
    expect(page).to have_selector '.rspec_recipe_body_results_size', text: '0'
    expect(page).to have_selector '.rspec_user_username_results_size', text: '0'
    expect(page).to have_selector '.rspec_user_profile_results_size', text: '0'
  end

  it 'returns correct results size', js: true do
    visit root_path
    click_link href: search_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: '味噌'
    click_button 'search'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '5'
    expect(page).to have_selector '.rspec_recipe_body_results_size', text: '4'
    expect(page).to have_selector '.rspec_user_username_results_size', text: '2'
    expect(page).to have_selector '.rspec_user_profile_results_size', text: '3'
  end

  it 'can AND search using space', js: true do
    visit root_path
    click_link href: search_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: '味噌 作り方'
    click_button 'search'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '1'
    expect(page).to have_selector '.rspec_recipe_body_results_size', text: '4'
    expect(page).to have_selector '.rspec_user_username_results_size', text: '0'
    expect(page).to have_selector '.rspec_user_profile_results_size', text: '2'
  end

  it 'and search using zenkaku spece', js: true do
    visit root_path
    click_link href: search_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: '味噌　作り方'
    click_button 'search'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '1'
    expect(page).to have_selector '.rspec_recipe_body_results_size', text: '4'
    expect(page).to have_selector '.rspec_user_username_results_size', text: '0'
    expect(page).to have_selector '.rspec_user_profile_results_size', text: '2'
  end
end
