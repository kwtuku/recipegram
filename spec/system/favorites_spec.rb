require 'rails_helper'

RSpec.describe 'Favorites', type: :system do
  let(:alice) { create(:user, :no_image) }
  let(:bob) { create(:user, :no_image) }
  let(:bob_recipe) { create(:recipe, :no_image, user: bob) }

  it 'creates a favorite', js: true do
    expect(Favorite.count).to eq 0
    sign_in alice
    visit recipe_path(bob_recipe)
    click_link href: recipe_favorites_path(bob_recipe)
    expect(page).to have_selector '.rspec_destroy_favorite'
    expect(Favorite.count).to eq 1
  end

  it 'destroys a favorite', js: true do
    alice.favorites.create!(recipe_id: bob_recipe.id)
    expect(Favorite.count).to eq 1
    sign_in alice
    visit recipe_path(bob_recipe)
    click_link href: recipe_favorites_path(bob_recipe)
    expect(page).to have_selector '.rspec_create_favorite'
    expect(Favorite.count).to eq 0
  end
end
