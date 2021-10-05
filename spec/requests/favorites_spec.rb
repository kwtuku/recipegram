require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  describe '#create' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:bob_recipe) { create :recipe, :no_image, user: bob }

    context 'when not signed in' do
      it 'returns a 401 response' do
        post recipe_favorites_path(bob_recipe), xhr: true
        expect(response.status).to eq 401
      end

      it 'does not increase Favorite count' do
        expect do
          post recipe_favorites_path(bob_recipe), xhr: true
        end.to change(Favorite, :count).by(0)
          .and change(bob_recipe.favorites, :count).by(0)
          .and change(alice.favorites, :count).by(0)
          .and change(alice.favored_recipes, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns a 200 response' do
        post recipe_favorites_path(bob_recipe), xhr: true
        expect(response.status).to eq 200
      end

      it 'increases Favorite count' do
        expect do
          post recipe_favorites_path(bob_recipe), xhr: true
        end.to change(Favorite, :count).by(1)
          .and change(bob_recipe.favorites, :count).by(1)
          .and change(alice.favorites, :count).by(1)
          .and change(alice.favored_recipes, :count).by(1)
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:bob_recipe) { create :recipe, :no_image, user: bob }

    before { alice.favorites.create(recipe_id: bob_recipe.id) }

    context 'when not signed in' do
      it 'returns a 401 response' do
        delete recipe_favorites_path(bob_recipe), xhr: true
        expect(response.status).to eq 401
      end

      it 'does not decrease Favorite count' do
        expect do
          delete recipe_favorites_path(bob_recipe), xhr: true
        end.to change(Favorite, :count).by(0)
          .and change(bob_recipe.favorites, :count).by(0)
          .and change(alice.favorites, :count).by(0)
          .and change(alice.favored_recipes, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns a 200 response' do
        delete recipe_favorites_path(bob_recipe), xhr: true
        expect(response.status).to eq 200
      end

      it 'decreases Favorite count' do
        expect do
          delete recipe_favorites_path(bob_recipe), xhr: true
        end.to change(Favorite, :count).by(-1)
          .and change(bob_recipe.favorites, :count).by(-1)
          .and change(alice.favorites, :count).by(-1)
          .and change(alice.favored_recipes, :count).by(-1)
      end
    end
  end
end
