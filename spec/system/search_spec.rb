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

  it 'returns no result' do
    visit root_path
    click_link href: search_path
    q_word = 'ごはん'
    q = Recipe.ransack({ "title_has_every_term" => q_word })
    results = q.result(distinct: true)
    fill_in 'q[title_has_every_term]', with: q_word
    click_button 'button'
    expect(page).to have_content '「ごはん」は見つかりませんでした。'
    expect(results.count).to eq 0
  end
  it 'returns result from recipe titles' do
    visit root_path
    click_link href: search_path
    q_word = '味噌'
    q = Recipe.ransack({ "title_has_every_term" => q_word })
    results = q.result(distinct: true)
    fill_in 'q[title_has_every_term]', with: q_word
    click_button 'button'
    expect(page).to have_link 'こってり味噌ラーメン'
    expect(page).to have_link 'さっぱり味噌ラーメン'
    expect(results.count).to eq 2
  end
  it 'and search using space' do
    visit root_path
    click_link href: search_path
    q_word = 'こってり ラーメン'
    q = Recipe.ransack({ "title_has_every_term" => q_word })
    results = q.result(distinct: true)
    fill_in 'q[title_has_every_term]', with: q_word
    click_button 'button'
    expect(page).to have_link 'こってり味噌ラーメン'
    expect(page).to have_link 'こってり塩ラーメン'
    expect(page).to have_link 'こってりしょうゆラーメン'
    expect(page).to have_link 'こってり豚骨ラーメン'
    expect(results.count).to eq 4
  end
  it 'and search using zenkaku spece' do
    visit root_path
    click_link href: search_path
    q_word = 'こってり　ラーメン'
    q = Recipe.ransack({ "title_has_every_term" => q_word })
    results = q.result(distinct: true)
    fill_in 'q[title_has_every_term]', with: q_word
    click_button 'button'
    expect(page).to have_link 'こってり味噌ラーメン'
    expect(page).to have_link 'こってり塩ラーメン'
    expect(page).to have_link 'こってりしょうゆラーメン'
    expect(page).to have_link 'こってり豚骨ラーメン'
    expect(results.count).to eq 4
  end
end
