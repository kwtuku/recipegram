require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe 'public pages' do
    let(:recipe) { create :recipe }

    it 'recipes#index returns a 200 response' do
      get recipes_path
      expect(response).to have_http_status(200)
    end

    it 'recipes#show returns a 200 response' do
      get recipe_path(recipe)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /recipes' do
    let(:alice) { create :user }

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
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:alice_recipe) { create :recipe, user: alice }

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
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:alice_recipe) { create :recipe, title: '?????????', user: alice }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        recipe_params = attributes_for(:recipe, title: '????????????')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in as wrong user' do
      it 'can not update other user recipe' do
        sign_in bob
        recipe_params = attributes_for(:recipe, title: '????????????')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq '?????????'
      end
    end

    context 'signed in as correct user' do
      it 'update recipe' do
        sign_in alice
        recipe_params = attributes_for(:recipe, title: '????????????')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq '????????????'
      end
    end
  end

  describe 'DELETE /recipes/:id' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:alice_recipe) { create :recipe, user: alice }

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
