require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:alice) { create(:user) }
  let(:bob) { create(:user) }
  let(:bob_recipe) { create(:recipe, :with_images, images_count: 1, user: bob) }

  it 'creates a comment', js: true do
    sign_in alice
    visit recipe_path(bob_recipe)
    expect(page).to have_button 'create_comment', disabled: true
    fill_in 'comment[body]', with: 'いいレシピですね！'
    expect do
      click_button 'create_comment'
    end.to change(Comment, :count).by(1)
    expect(page).to have_content 'レシピにコメントしました。'
  end

  it 'destroys a comment', js: true do
    create(:comment, recipe: bob_recipe, user: alice)
    expect(Comment.count).to eq 1
    sign_in alice
    visit recipe_path(bob_recipe)
    find('.rspec_comment_dropdown_trigger').click
    click_link '削除する'
    page.accept_confirm
    expect(page).to have_content 'コメントを削除しました。'
    expect(Comment.count).to eq 0
  end
end
