require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:alice) { create :user }
  let(:bob) { create :user }
  let(:bob_recipe) { create :recipe, user: bob }

  it 'create comment', js: true do
    sign_in alice
    visit recipe_path(bob_recipe)
    expect(page).to have_button 'create_comment', disabled: true
    fill_in 'comment[body]', with: 'いいレシピですね！'
    expect{ click_button 'create_comment' }.to change { bob_recipe.comments.count }.by(1)
    expect(page).to have_content 'レシピにコメントしました。'
  end
end
