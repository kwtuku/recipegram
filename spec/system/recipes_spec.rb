require 'rails_helper'

RSpec.describe 'Recipes', type: :system do
  let(:alice) { create :user, :no_image }
  let(:bob) { create :user, :no_image }

  it 'creates a recipe', js: true do
    sign_in alice
    click_link href: new_recipe_path
    expect(page).to have_current_path new_recipe_path
    expect(page).to have_button 'create_recipe', disabled: true
    image_path = Rails.root.join('spec/fixtures/recipe_image_sample.jpg')
    attach_file 'recipe[recipe_image]', image_path, visible: false
    fill_in 'recipe[title]', with: '野菜炒め'
    fill_in 'recipe[body]', with: '野菜を切って炒める。'
    expect { click_button 'create_recipe' }.to change(alice.recipes, :count).by(1)
    expect(page).to have_content 'レシピを投稿しました。'
  end

  describe 'updates the recipe' do
    let(:alice_recipe) { create :recipe, user: alice }

    context 'when signed in as wrong user' do
      it 'redirects to recipe_path', js: true do
        sign_in bob
        visit edit_recipe_path(alice_recipe)
        expect(page).to have_current_path recipe_path(alice_recipe)
        expect(page).to have_content '権限がありません。'
      end
    end

    context 'when signed in as correct user' do
      it 'updates title', js: true do
        sign_in alice
        visit edit_recipe_path(alice_recipe)
        expect(page).to have_button 'update_recipe', disabled: true
        fill_in 'recipe[title]', with: 'クリームシチュー'
        click_button 'update_recipe'
        expect(page).to have_content 'レシピを編集しました。'
        expect(alice_recipe.reload.title).to eq 'クリームシチュー'
      end

      it 'updates body', js: true do
        sign_in alice
        visit edit_recipe_path(alice_recipe)
        expect(page).to have_button 'update_recipe', disabled: true
        fill_in 'recipe[body]', with: '切ったにんじん、玉ねぎ、じゃがいも、肉とクリームシチューのルーと水を鍋に入れて煮込む。'
        click_button 'update_recipe'
        expect(page).to have_content 'レシピを編集しました。'
        expect(alice_recipe.reload.body).to eq '切ったにんじん、玉ねぎ、じゃがいも、肉とクリームシチューのルーと水を鍋に入れて煮込む。'
      end

      it 'updates recipe_image', js: true do
        sign_in alice
        before_image_url = alice_recipe.recipe_image.url
        visit edit_recipe_path(alice_recipe)
        expect(page).to have_button 'update_recipe', disabled: true
        image_path = Rails.root.join('spec/fixtures/recipe_image_sample_after.jpg')
        attach_file 'recipe[recipe_image]', image_path, visible: false
        click_button 'update_recipe'
        after_image_url = alice_recipe.reload.recipe_image.url
        expect(before_image_url).not_to eq after_image_url
        expect(page).to have_content 'レシピを編集しました。'
      end
    end
  end

  it 'destroys the recipe', js: true do
    alice_recipe = create :recipe, :no_image, user: alice
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
