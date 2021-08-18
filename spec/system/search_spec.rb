require 'rails_helper'

RSpec.describe 'Search', type: :system do
  let!(:miso_ramen) { create :recipe, :no_image, title: '味噌ラーメンの作り方', body: '味噌ラーメンの作り方です。' }
  let!(:miso_soup) { create :recipe, :no_image, title: '味噌汁', body: '味噌汁の作り方です。' }
  let!(:miso_katsudon) { create :recipe, :no_image, title: '味噌カツ丼', body: '味噌カツ丼の作り方です。' }
  let!(:miso_udon) { create :recipe, :no_image, title: '味噌煮込みうどん', body: '味噌煮込みうどんの作り方です。' }
  let!(:miso) { create :recipe, :no_image, title: '味噌', body: 'みその作り方です。' }
  let!(:tonkotsu_ramen) { create :recipe, :no_image, title: '豚骨ラーメン', body: '豚骨ラーメンの作り方です。' }

  let!(:miso_ramen_man) { create :user, :no_image, nickname: '味噌ラーメン大好きマン', profile: '味噌ラーメン大好き' }
  let!(:alice) { create :user, :no_image, nickname: 'アリス', profile: '味噌ラーメンの作り方知ってます。' }
  let!(:bob) { create :user, :no_image, nickname: 'ボブ', profile: '味噌カツ丼の作り方知りたい！' }
  let!(:carol) { create :user, :no_image, nickname: '味噌好きキャロル', profile: 'みそ汁が作れます。' }
  let!(:dave) { create :user, :no_image, nickname: 'dave', profile: 'I am dave.' }

  it 'returns no result', js: true do
    visit root_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: 'ごはん'
    click_button 'search'
    within '.rspec_recipe_title_results' do
      expect(page).to have_content '「ごはん」は見つかりませんでした。'
    end
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '0'
    expect(page).to have_selector '.rspec_recipe_body_results_size', text: '0'
    expect(page).to have_selector '.rspec_user_nickname_results_size', text: '0'
    expect(page).to have_selector '.rspec_user_profile_results_size', text: '0'
  end

  it 'returns correct results size', js: true do
    visit root_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: '味噌'
    click_button 'search'
    expect(page).to have_selector '.rspec_recipe_title_results_size', text: '5'
    expect(page).to have_selector '.rspec_recipe_body_results_size', text: '4'
    expect(page).to have_selector '.rspec_user_nickname_results_size', text: '2'
    expect(page).to have_selector '.rspec_user_profile_results_size', text: '3'
  end

  it 'keeps search keyword', js: true do
    visit root_path
    expect(page).to have_button 'search', disabled: true
    fill_in 'search_query', with: '味噌'
    click_button 'search'
    expect(find('#search_query').value).to eq '味噌'
  end

  describe 'AND search' do
    it 'using space', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌 作り方'
      click_button 'search'
      expect(page).to have_selector '.rspec_recipe_title_results_size', text: '1'
      expect(page).to have_selector '.rspec_recipe_body_results_size', text: '4'
      expect(page).to have_selector '.rspec_user_nickname_results_size', text: '0'
      expect(page).to have_selector '.rspec_user_profile_results_size', text: '2'
    end

    it 'using zenkaku spece', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌　作り方'
      click_button 'search'
      expect(page).to have_selector '.rspec_recipe_title_results_size', text: '1'
      expect(page).to have_selector '.rspec_recipe_body_results_size', text: '4'
      expect(page).to have_selector '.rspec_user_nickname_results_size', text: '0'
      expect(page).to have_selector '.rspec_user_profile_results_size', text: '2'
    end
  end

  describe 'show correct condition results' do
    it 'recipe title', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌'
      click_button 'search'
      expect(page).to have_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
    end

    it 'recipe body', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌'
      click_button 'search'
      within '.menu' do
        click_link '作り方'
      end
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
    end

    it 'user nickname', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌'
      click_button 'search'
      within '.menu' do
        click_link 'ニックネーム'
      end
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
    end

    it 'user nickname', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌'
      click_button 'search'
      within '.menu' do
        click_link 'プロフィール'
      end
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_css '.rspec_user_profile_results'
    end
  end

  describe 'keep condition' do
    it 'recipe title', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌'
      click_button 'search'
      within '.menu' do
        click_link 'レシピ名'
      end
      expect(page).to have_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
      fill_in 'search_query', with: 'ラーメン'
      click_button 'search'
      expect(page).to have_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
    end

    it 'recipe body', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌'
      click_button 'search'
      within '.menu' do
        click_link '作り方'
      end
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
      fill_in 'search_query', with: 'ラーメン'
      click_button 'search'
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
    end

    it 'user nickname', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌'
      click_button 'search'
      within '.menu' do
        click_link 'ニックネーム'
      end
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
      fill_in 'search_query', with: 'ラーメン'
      click_button 'search'
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_css '.rspec_user_nickname_results'
      expect(page).to have_no_css '.rspec_user_profile_results'
    end

    it 'user profile', js: true do
      visit root_path
        expect(page).to have_button 'search', disabled: true
      fill_in 'search_query', with: '味噌'
      click_button 'search'
      within '.menu' do
        click_link 'プロフィール'
      end
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_css '.rspec_user_profile_results'
      fill_in 'search_query', with: 'ラーメン'
      click_button 'search'
      expect(page).to have_no_css '.rspec_recipe_title_results'
      expect(page).to have_no_css '.rspec_recipe_body_results'
      expect(page).to have_no_css '.rspec_user_nickname_results'
      expect(page).to have_css '.rspec_user_profile_results'
    end
  end
end
