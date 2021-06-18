require 'rails_helper'

RSpec.describe 'Favorites', type: :system do
  let(:user) { create :user }
  let(:other_user) { create :user,  :with_recipes }
  let(:other_user_recipe) { other_user.recipes[0] }

  it 'create favorite', js: true do
    sign_in user
    visit recipe_path(other_user_recipe)
    click_link href: recipe_favorites_path(other_user_recipe)
    expect(page).to have_selector '.rspec_destroy_favorite'
    expect(other_user_recipe.favorites.count).to eq 1
  end
  it 'destroy favorite', js: true do
    other_user_recipe.favorites.create!(user_id: user.id)
    expect(other_user_recipe.favorites.count).to eq 1
    sign_in user
    visit recipe_path(other_user_recipe)
    click_link href: recipe_favorites_path(other_user_recipe)
    expect(page).to have_selector '.rspec_create_favorite'
    expect(other_user_recipe.favorites.count).to eq 0
  end
end
