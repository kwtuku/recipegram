require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:alice) { create :user, :no_image }
  let(:bob) { create :user, :no_image }
  let(:bob_recipe) { create :recipe, :no_image, user: bob }

  it 'creates a comment', js: true do
    sign_in alice
    visit recipe_path(bob_recipe)
    expect(page).to have_button 'create_comment', disabled: true
    fill_in 'comment[body]', with: 'いいレシピですね！'
    expect{
      click_button 'create_comment'
    }.to change { bob_recipe.comments.count }.by(1)
    .and change { alice.comments.count }.by(1)
    .and change { alice.commented_recipes.count }.by(1)
    expect(page).to have_content 'レシピにコメントしました。'
  end
end
