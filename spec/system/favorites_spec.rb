require 'rails_helper'

RSpec.describe 'Favorites', type: :system do
  let(:alice) { create :user }
  let(:bob) { create :user }
  let(:bob_recipe) { create :recipe, user: bob }

  it 'create favorite', js: true do
    sign_in alice
    visit recipe_path(bob_recipe)
    click_link href: recipe_favorites_path(bob_recipe)
    expect(page).to have_selector '.rspec_destroy_favorite'
    expect(bob_recipe.favorites.count).to eq 1
  end
  it 'destroy favorite', js: true do
    bob_recipe.favorites.create!(user_id: alice.id)
    expect(bob_recipe.favorites.count).to eq 1
    sign_in alice
    visit recipe_path(bob_recipe)
    click_link href: recipe_favorites_path(bob_recipe)
    expect(page).to have_selector '.rspec_create_favorite'
    expect(bob_recipe.favorites.count).to eq 0
  end
end
