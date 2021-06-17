require 'rails_helper'

RSpec.describe 'Recipes', type: :system do
  let(:user) { create :user,  :with_recipes }
  let(:other_user) { create :user,  :with_recipes }

  it 'create recipe', js: true do
    sign_in user
    click_link href: new_recipe_path
    expect(current_path).to eq new_recipe_path
    expect(page).to have_button 'create_recipe', disabled: true
    attach_file 'recipe[recipe_image]', "#{Rails.root}/spec/fixtures/recipe_image_sample.jpg", visible: false
    fill_in 'recipe[title]', with: '野菜炒め'
    fill_in 'recipe[body]', with: '野菜を切って炒める。'
    expect{ click_button 'create_recipe' }.to change { Recipe.count }.by(1)
    expect(page).to have_content 'レシピを投稿しました。'
  end

  describe 'edit recipe' do
    context 'signed in as wrong user' do
      it 'can not edit', js: true do
        sign_in other_user
        visit edit_recipe_path(user.recipes[0])
        expect(current_path).to eq recipe_path(user.recipes[0])
        expect(page).to have_content '権限がありません。'
      end
    end

    context 'signed in as correct user' do
      it 'edit title', js: true do
        sign_in user
        visit edit_recipe_path(user.recipes[0])
        expect(page).to have_button 'update_recipe', disabled: true
        fill_in 'recipe[title]', with: 'クリームシチュー'
        click_button 'update_recipe'
        expect(page).to have_content 'レシピを編集しました。'
        expect(user.recipes[0].reload.title).to eq 'クリームシチュー'
      end
      it 'edit body', js: true do
        sign_in user
        visit edit_recipe_path(user.recipes[0])
        expect(page).to have_button 'update_recipe', disabled: true
        fill_in 'recipe[body]', with: '切ったにんじん、玉ねぎ、じゃがいも、肉とクリームシチューのルーと水を鍋に入れて煮込む。'
        click_button 'update_recipe'
        expect(page).to have_content 'レシピを編集しました。'
        expect(user.recipes[0].reload.body).to eq '切ったにんじん、玉ねぎ、じゃがいも、肉とクリームシチューのルーと水を鍋に入れて煮込む。'
      end
      it 'edit recipe_image', js: true do
        sign_in user
        visit edit_recipe_path(user.recipes[0])
        expect(page).to have_button 'update_recipe', disabled: true
        attach_file 'recipe[recipe_image]', "#{Rails.root}/spec/fixtures/recipe_image_sample_after.jpg", visible: false
        click_button 'update_recipe'
        expect(page).to have_content 'レシピを編集しました。'
        expect(page).to have_selector("img[src$='recipe_image_sample_after.jpg']")
      end
    end
  end
end
