require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe '#index' do
    before { create_list(:recipe, 5, :no_image) }
    let(:alice) { create :user, :no_image }

    it 'returns a 200 response when not signed in' do
      get recipes_path
      expect(response).to have_http_status(200)
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get recipes_path
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    let(:alice) { create :user, :no_image }
    let(:recipe) { create :recipe, :no_image }

    it 'returns a 200 response when not signed in' do
      get recipe_path(recipe)
      expect(response).to have_http_status(200)
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get recipe_path(recipe)
      expect(response).to have_http_status(200)
    end
  end

  describe '#new' do
    let(:alice) { create :user, :no_image }

    it 'redirects to new_user_session_path when not signed in' do
      get new_recipe_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'returns a 200 response when signed in' do
      sign_in alice
      get new_recipe_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /recipes' do
    let(:alice) { create :user, :no_image }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        recipe_params = attributes_for(:recipe)
        expect {
          post recipes_path, params: { recipe: recipe_params }
        }.to change { Recipe.count }.by(0)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in' do
      it 'create recipe' do
        sign_in alice
        recipe_params = attributes_for(:recipe, user: alice)
        expect {
          post recipes_path, params: { recipe: recipe_params }
        }.to change { alice.recipes.count }.by(1)
      end
    end
  end

  describe 'GET /recipes/:id/edit' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:alice_recipe) { create :recipe, :no_image, user: alice }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        get edit_recipe_path(alice_recipe)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in as wrong user' do
      it 'redirect_to recipe_path(alice_recipe)' do
        sign_in bob
        get edit_recipe_path(alice_recipe)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end
    end

    context 'signed in as correct user' do
      it 'returns a 200 response' do
        sign_in alice
        get edit_recipe_path(alice_recipe)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH /recipes/:id' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:alice_recipe) { create :recipe, :no_image, title: 'カレー', user: alice }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in as wrong user' do
      it 'can not update other user recipe' do
        sign_in bob
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq 'カレー'
      end
    end

    context 'signed in as correct user' do
      it 'update recipe' do
        sign_in alice
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq 'ラーメン'
      end
    end
  end

  describe 'DELETE /recipes/:id' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let!(:alice_recipe) { create :recipe, :no_image, user: alice }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        expect {
          delete recipe_path(alice_recipe)
        }.to change { alice.recipes.count }.by(0)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in as wrong user' do
      it 'can not destroy other user recipe' do
        sign_in bob
        expect {
          delete recipe_path(alice_recipe)
        }.to change { alice.recipes.count }.by(0)
      end
    end

    context 'signed in as correct user' do
      it 'destroy recipe' do
        sign_in alice
        expect {
          delete recipe_path(alice_recipe)
        }.to change { alice.recipes.count }.by(-1)
      end
    end
  end
end
