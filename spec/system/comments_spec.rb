require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:other_user_recipe) { create :recipe, user: other_user }

  it 'create comment', js: true do
    sign_in user
    visit recipe_path(other_user_recipe)
    expect(page).to have_button 'create_comment', disabled: true
    fill_in 'comment[body]', with: 'いいレシピですね！'
    expect{ click_button 'create_comment' }.to change { other_user_recipe.comments.count }.by(1)
    expect(page).to have_content 'レシピにコメントしました。'
  end
end
