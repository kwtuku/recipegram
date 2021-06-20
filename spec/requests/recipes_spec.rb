require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe 'public' do
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

  describe 'GET /recipes/:id/edit' do
    let(:user) { create :user, :with_recipes, username: 'user' }
    let(:other_user) { create :user, username: 'other_user' }
    let(:user_recipe) { user.recipes[0] }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        get edit_recipe_path(user_recipe)
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'signed in as wrong user' do
      it 'redirecto_to recipe_path(user_recipe)' do
        sign_in other_user
        get edit_recipe_path(user_recipe)
        expect(response).to redirect_to recipe_path(user_recipe)
      end
    end
    context 'signed in as correct user' do
      it 'returns a 200 response' do
        sign_in user
        get edit_recipe_path(user_recipe)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH /recipes/:id' do
    let(:user) { create :user, :with_recipes, username: 'user' }
    let(:other_user) { create :user, username: 'other_user' }
    let(:recipe) { create :recipe }
    let(:user_recipe) { create :recipe, title: 'カレー', user: user }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(user_recipe), params: { id: user_recipe.id, recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'signed in as wrong user' do
      it 'can not update recipe' do
        sign_in other_user
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(user_recipe), params: { id: user_recipe.id, recipe: recipe_params }
        expect(user_recipe.reload.title).to eq 'カレー'
      end
    end
    context 'signed in as correct user' do
      it 'update recipe' do
        sign_in user
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(user_recipe), params: { id: user_recipe.id, recipe: recipe_params }
        expect(user_recipe.reload.title).to eq 'ラーメン'
      end
    end
  end

  describe 'DELETE /recipes/:id' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let!(:user_recipe) { create :recipe, user: user }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        delete recipe_path(user_recipe), params: { id: user_recipe.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'signed in as wrong user' do
      it 'can not destroy recipe' do
        sign_in other_user
        expect {
          delete recipe_path(user_recipe), params: { id: user_recipe.id }
        }.to change { user.recipes.count }.by(0)
      end
    end
    context 'signed in as correct user' do
      it 'destroy recipe' do
        sign_in user
        expect {
          delete recipe_path(user_recipe), params: { id: user_recipe.id }
        }.to change { user.recipes.count }.by(-1)
      end
    end
  end
end
