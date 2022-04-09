require 'rails_helper'

RSpec.describe 'Recipes', type: :system do
  let(:alice) { create(:user) }

  describe 'updates the recipe' do
    let(:alice_recipe) { create(:recipe, :with_images, user: alice) }
    let(:bob) { create(:user) }

    context 'when user is not the author' do
      it 'redirects to root_path', js: true do
        sign_in bob
        visit edit_recipe_path(alice_recipe)
        expect(page).to have_current_path root_path
        expect(page).to have_content '権限がありません。'
      end
    end

    context 'when user is the author' do
      it 'updates the recipe', js: true do
        sign_in alice
        visit edit_recipe_path(alice_recipe)
        fill_in 'recipe[title]', with: 'クリームシチュー'
        fill_in 'recipe[body]', with: '切ったにんじん、玉ねぎ、じゃがいも、肉とクリームシチューのルーと水を鍋に入れて煮込む。'
        fill_in 'recipe[tag_list]', with: 'かんたん,お手軽', visible: false
        click_button 'update_recipe'
        expect(page).to have_content 'レシピを編集しました。'
        alice_recipe.reload
        expect(alice_recipe.title).to eq 'クリームシチュー'
        expect(alice_recipe.body).to eq '切ったにんじん、玉ねぎ、じゃがいも、肉とクリームシチューのルーと水を鍋に入れて煮込む。'
        expect(alice_recipe.tag_list).to match_array %w[かんたん お手軽]
      end
    end
  end

  it 'destroys the recipe', js: true do
    alice_recipe = create(:recipe, :with_images, images_count: 1, user: alice)
    expect(alice.recipes.count).to eq 1
    sign_in alice
    visit recipe_path(alice_recipe)
    find('.rspec_recipe_dropdown_trigger').click
    click_link '削除する'
    page.accept_confirm
    expect(page).to have_content 'レシピを削除しました。'
    expect(alice.recipes.count).to eq 0
  end
end
