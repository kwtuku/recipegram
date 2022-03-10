require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  describe 'POST /recipes/:recipe_id/favorites' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:bob_recipe) { create(:recipe, :no_image, user: bob) }

    context 'when not signed in' do
      it 'returns unauthorized' do
        post recipe_favorites_path(bob_recipe), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not increase Favorite count' do
        expect do
          post recipe_favorites_path(bob_recipe), xhr: true
        end.to change(Favorite, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        post recipe_favorites_path(bob_recipe), xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'increases Favorite count' do
        expect do
          post recipe_favorites_path(bob_recipe), xhr: true
        end.to change(Favorite, :count).by(1)
      end
    end
  end

  describe 'DELETE /recipes/:recipe_id/favorites' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:bob_recipe) { create(:recipe, :no_image, user: bob) }

    before { alice.favorites.create(recipe_id: bob_recipe.id) }

    context 'when not signed in' do
      it 'returns unauthorized' do
        delete recipe_favorites_path(bob_recipe), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not decrease Favorite count' do
        expect do
          delete recipe_favorites_path(bob_recipe), xhr: true
        end.to change(Favorite, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        delete recipe_favorites_path(bob_recipe), xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'decreases Favorite count' do
        expect do
          delete recipe_favorites_path(bob_recipe), xhr: true
        end.to change(Favorite, :count).by(-1)
      end
    end
  end
end
