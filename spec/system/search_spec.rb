require 'rails_helper'

RSpec.describe 'Search', type: :system do
  before do
    alice = create :user, :no_image, nickname: 'アリス', profile: '味噌ラーメンが好き'
    create :user, :no_image, nickname: 'ボブ', profile: 'しょうゆらーめんが好き'
    create :user, :no_image, nickname: 'キャロル', profile: '塩らーめんが好き'
    create :user, :no_image, nickname: 'dave', profile: 'I like tonkotsu ramen'

    create :recipe, :no_image, title: '味噌ラーメン', body: '味噌らーめんの作り方です。', user: alice
    create :recipe, :no_image, title: 'しょうゆラーメン', body: 'しょうゆラーメンの作り方です。', user: alice
    create :recipe, :no_image, title: '塩ラーメン', body: '塩ラーメンの作り方です。', user: alice
    create :recipe, :no_image, title: 'とんこつらーめん', body: 'とんこつらーめんの作り方です。', user: alice
  end

  context 'when no results' do
    it 'returns correct result counts', js: true do
      visit root_path
      fill_in 'q', with: "ごはん\n"
      expect(page).to have_content '「ごはん」は見つかりませんでした。'
      expect(page).to have_selector '[data-rspec=recipe_title_result_count]', text: '0'
      expect(page).to have_selector '[data-rspec=recipe_body_result_count]', text: '0'
      expect(page).to have_selector '[data-rspec=user_nickname_result_count]', text: '0'
      expect(page).to have_selector '[data-rspec=user_profile_result_count]', text: '0'
    end
  end

  context 'when results exist' do
    it 'returns correct result counts', js: true do
      visit root_path
      fill_in 'q', with: "ラーメン\n"
      expect(page).to have_selector '[data-rspec=recipe_title_result_count]', text: '3'
      expect(page).to have_selector '[data-rspec=recipe_body_result_count]', text: '2'
      expect(page).to have_selector '[data-rspec=user_nickname_result_count]', text: '0'
      expect(page).to have_selector '[data-rspec=user_profile_result_count]', text: '1'
    end

    it 'keeps search keyword on form', js: true do
      visit root_path
      fill_in 'q', with: "ラーメン\n"
      expect(find('#q').value).to eq 'ラーメン'
    end

    it 'can AND search using space', js: true do
      visit root_path
      fill_in 'q', with: "ラーメン 作り方\n"
      expect(page).to have_selector '[data-rspec=recipe_title_result_count]', text: '0'
      expect(page).to have_selector '[data-rspec=recipe_body_result_count]', text: '2'
      expect(page).to have_selector '[data-rspec=user_nickname_result_count]', text: '0'
      expect(page).to have_selector '[data-rspec=user_profile_result_count]', text: '0'
    end

    it 'can AND search using zenkaku spece', js: true do
      visit root_path
      fill_in 'q', with: "ラーメン　作り方\n"
      expect(page).to have_selector '[data-rspec=recipe_title_result_count]', text: '0'
      expect(page).to have_selector '[data-rspec=recipe_body_result_count]', text: '2'
      expect(page).to have_selector '[data-rspec=user_nickname_result_count]', text: '0'
      expect(page).to have_selector '[data-rspec=user_profile_result_count]', text: '0'
    end
  end

  context 'when search_path has source param' do
    before do
      visit root_path
      fill_in 'q', with: "ラーメン\n"
    end

    it 'shows recipe title results', js: true do
      within '.menu' do
        click_link 'レシピ名'
      end
      expect(page).to have_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
    end

    it 'shows recipe body results', js: true do
      within '.menu' do
        click_link '作り方'
      end
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
    end

    it 'shows user nickname results', js: true do
      within '.menu' do
        click_link 'ニックネーム'
      end
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
    end

    it 'shows user profile results', js: true do
      within '.menu' do
        click_link 'プロフィール'
      end
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_css '[data-rspec=user_profile_results]'
    end
  end

  context 'when search again' do
    before do
      visit root_path
      fill_in 'q', with: "ラーメン\n"
    end

    it 'shows recipe title results again', js: true do
      within '.menu' do
        click_link 'レシピ名'
      end
      expect(page).to have_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
      fill_in 'q', with: "らーめん\n"
      expect(page).to have_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
    end

    it 'shows recipe body results again', js: true do
      within '.menu' do
        click_link '作り方'
      end
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
      fill_in 'q', with: "らーめん\n"
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
    end

    it 'shows user nickname results again', js: true do
      within '.menu' do
        click_link 'ニックネーム'
      end
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
      fill_in 'q', with: "らーめん\n"
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_css '[data-rspec=user_nickname_results]'
      expect(page).to have_no_css '[data-rspec=user_profile_results]'
    end

    it 'shows user profile results again', js: true do
      within '.menu' do
        click_link 'プロフィール'
      end
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_css '[data-rspec=user_profile_results]'
      fill_in 'q', with: "らーめん\n"
      expect(page).to have_no_css '[data-rspec=recipe_title_results]'
      expect(page).to have_no_css '[data-rspec=recipe_body_results]'
      expect(page).to have_no_css '[data-rspec=user_nickname_results]'
      expect(page).to have_css '[data-rspec=user_profile_results]'
    end
  end
end
