require 'rails_helper'

RSpec.describe 'Recipes', type: :system do
  let(:alice) { create :user, :no_image }
  let(:bob) { create :user, :no_image }

  it 'creates a recipe', js: true do
    sign_in alice
    click_link href: new_recipe_path
    expect(current_path).to eq new_recipe_path
    expect(page).to have_button 'create_recipe', disabled: true
    attach_file 'recipe[recipe_image]', "#{Rails.root}/spec/fixtures/recipe_image_sample.jpg", visible: false
    fill_in 'recipe[title]', with: '野菜炒め'
    fill_in 'recipe[body]', with: '野菜を切って炒める。'
    expect{ click_button 'create_recipe' }.to change { alice.recipes.count }.by(1)
    expect(page).to have_content 'レシピを投稿しました。'
  end

  describe 'edit recipe' do
    let(:alice_recipe) { create :recipe, user: alice }

    context 'signed in as wrong user' do
      it 'can not edit', js: true do
        sign_in bob
        visit edit_recipe_path(alice_recipe)
        expect(current_path).to eq recipe_path(alice_recipe)
        expect(page).to have_content '権限がありません。'
      end
    end

    context 'signed in as correct user' do
      it 'edit title', js: true do
        sign_in alice
        visit edit_recipe_path(alice_recipe)
        expect(page).to have_button 'update_recipe', disabled: true
        fill_in 'recipe[title]', with: 'クリームシチュー'
        click_button 'update_recipe'
        expect(page).to have_content 'レシピを編集しました。'
        expect(alice_recipe.reload.title).to eq 'クリームシチュー'
      end

      it 'edit body', js: true do
        sign_in alice
        visit edit_recipe_path(alice_recipe)
        expect(page).to have_button 'update_recipe', disabled: true
        fill_in 'recipe[body]', with: '切ったにんじん、玉ねぎ、じゃがいも、肉とクリームシチューのルーと水を鍋に入れて煮込む。'
        click_button 'update_recipe'
        expect(page).to have_content 'レシピを編集しました。'
        expect(alice_recipe.reload.body).to eq '切ったにんじん、玉ねぎ、じゃがいも、肉とクリームシチューのルーと水を鍋に入れて煮込む。'
      end

      it 'edit recipe_image', js: true do
        sign_in alice
        before_image_public_id = alice_recipe.recipe_image.public_id
        visit edit_recipe_path(alice_recipe)
        expect(page).to have_button 'update_recipe', disabled: true
        attach_file 'recipe[recipe_image]', "#{Rails.root}/spec/fixtures/recipe_image_sample_after.jpg", visible: false
        click_button 'update_recipe'
        after_image_public_id = alice_recipe.reload.recipe_image.public_id
        expect(before_image_public_id).to_not eq after_image_public_id
        expect(page).to have_content 'レシピを編集しました。'
      end
    end
  end
end
