require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  describe '#create' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:alice_recipe) { create :recipe, :no_image, user: alice }

    context 'when not signed in' do
      it 'does not increase Favorite count' do
        expect {
          post recipe_favorites_path(alice_recipe), xhr: true
        }.to change { Favorite.count }.by(0)
      end

      it 'does not increase Recipe.favorites count' do
        expect {
          post recipe_favorites_path(alice_recipe), xhr: true
        }.to change { alice_recipe.favorites.count }.by(0)
      end

      it 'does not increase User.favorites count' do
        expect {
          post recipe_favorites_path(alice_recipe), xhr: true
        }.to change { bob.favorites.count }.by(0)
      end

      it 'returns a 401 response' do
        post recipe_favorites_path(alice_recipe), xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'when signed in' do
      it 'increases Favorite count' do
        sign_in bob
        expect {
          post recipe_favorites_path(alice_recipe), xhr: true
        }.to change { Favorite.count }.by(1)
      end

      it 'increases Recipe.favorites count' do
        sign_in bob
        expect {
          post recipe_favorites_path(alice_recipe), xhr: true
        }.to change { alice_recipe.favorites.count }.by(1)
      end

      it 'increases User.favorites count' do
        sign_in bob
        expect {
          post recipe_favorites_path(alice_recipe), xhr: true
        }.to change { bob.favorites.count }.by(1)
      end

      it 'returns a 200 response' do
        sign_in bob
        post recipe_favorites_path(alice_recipe), xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:alice_recipe) { create :recipe, :no_image, user: alice }
    before do
      bob.favorites.create(recipe_id: alice_recipe.id)
    end

    context 'when not signed in' do
      it 'does not decrease Favorite count' do
        expect {
          delete recipe_favorites_path(alice_recipe), xhr: true
        }.to change { Favorite.count }.by(0)
      end

      it 'does not decrease Recipe.favorites count' do
        expect {
          delete recipe_favorites_path(alice_recipe), xhr: true
        }.to change { alice_recipe.favorites.count }.by(0)
      end

      it 'does not decrease User.favorites count' do
        expect {
          delete recipe_favorites_path(alice_recipe), xhr: true
        }.to change { bob.favorites.count }.by(0)
      end

      it 'returns a 401 response' do
        delete recipe_favorites_path(alice_recipe), xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'when signed in' do
      it 'decreases Favorite count' do
        sign_in bob
        expect {
          delete recipe_favorites_path(alice_recipe), xhr: true
        }.to change { Favorite.count }.by(-1)
      end

      it 'decreases Recipe.favorites count' do
        sign_in bob
        expect {
          delete recipe_favorites_path(alice_recipe), xhr: true
        }.to change { alice_recipe.favorites.count }.by(-1)
      end

      it 'decreases User.favorites count' do
        sign_in bob
        expect {
          delete recipe_favorites_path(alice_recipe), xhr: true
        }.to change { bob.favorites.count }.by(-1)
      end

      it 'returns a 200 response' do
        sign_in bob
        delete recipe_favorites_path(alice_recipe), xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end
end
