require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:alice) { create(:user, :no_image) }
  let(:bob) { create(:user, :no_image) }
  let(:bob_recipe) { create(:recipe, :no_image, user: bob) }

  it 'creates a comment', js: true do
    sign_in alice
    visit recipe_path(bob_recipe)
    expect(page).to have_button 'create_comment', disabled: true
    fill_in 'comment[body]', with: 'いいレシピですね！'
    expect do
      click_button 'create_comment'
    end.to change(Comment, :count).by(1)
      .and change(bob_recipe.comments, :count).by(1)
      .and change(alice.comments, :count).by(1)
      .and change(alice.commented_recipes, :count).by(1)
    expect(page).to have_content 'レシピにコメントしました。'
  end

  it 'destroys a comment', js: true do
    alice.comments.create!(recipe_id: bob_recipe.id, body: 'いいレシピですね！')
    counts = [Comment.count, bob_recipe.comments.count, alice.comments.count, alice.commented_recipes.count]
    expect(counts).to eq [1, 1, 1, 1]
    sign_in alice
    visit recipe_path(bob_recipe)
    find('.rspec_comment_dropdown_trigger').click
    click_link '削除する'
    page.accept_confirm
    expect(page).to have_content 'コメントを削除しました。'
    counts = [Comment.count, bob_recipe.comments.count, alice.comments.count, alice.commented_recipes.count]
    expect(counts).to eq [0, 0, 0, 0]
  end
end
