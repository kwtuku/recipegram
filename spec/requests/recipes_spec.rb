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
end
