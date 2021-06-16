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
  end
end
