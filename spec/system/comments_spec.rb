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

  it 'destroys a comment', js: true do
    bob_recipe.comments.create!(user_id: alice.id, body: 'いいレシピですね！')
    expect(bob_recipe.comments.count).to eq 1
    expect(alice.comments.count).to eq 1
    expect(alice.commented_recipes.count).to eq 1

    sign_in alice
    visit recipe_path(bob_recipe)
    find('.rspec_comment_dropdown_trigger').click
    click_link '削除する'
    page.accept_confirm
    expect(page).to have_content 'コメントを削除しました。'
    expect(bob_recipe.comments.count).to eq 0
    expect(alice.comments.count).to eq 0
    expect(alice.commented_recipes.count).to eq 0
  end
end
