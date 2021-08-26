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
    let(:bob) { create :user, :no_image }
    let(:bob_recipe) { create :recipe, :no_image }

    context 'when not signed in and other recipes exist' do
      it 'returns a 200 response' do
        create_list(:recipe, 5, :no_image, user: bob)
        get recipe_path(bob_recipe)
        expect(response).to have_http_status(200)
      end
    end

    context 'when not signed in and other recipes do not exist' do
      it 'returns a 200 response' do
        get recipe_path(bob_recipe)
        expect(response).to have_http_status(200)
      end
    end

    context 'when signed in and other recipes exist' do
      it 'returns a 200 response' do
        create_list(:recipe, 5, :no_image, user: bob)
        sign_in alice
        get recipe_path(bob_recipe)
        expect(response).to have_http_status(200)
      end
    end

    context 'when signed in and other recipes do not exist' do
      it 'returns a 200 response' do
        sign_in alice
        get recipe_path(bob_recipe)
        expect(response).to have_http_status(200)
      end
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

  describe '#create' do
    let(:alice) { create :user, :no_image }

    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        recipe_params = attributes_for(:recipe)
        post recipes_path, params: { recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Recipe count' do
        recipe_params = attributes_for(:recipe)
        expect {
          post recipes_path, params: { recipe: recipe_params }
        }.to change { Recipe.count }.by(0)
      end
    end

    context 'when signed in' do
      it 'increases Recipe count' do
        sign_in alice
        recipe_params = attributes_for(:recipe, user: alice)
        expect {
          post recipes_path, params: { recipe: recipe_params }
        }.to change { Recipe.count }.by(1)
        .and change { alice.recipes.count }.by(1)
      end

      it 'redirects to recipe_path(new_recipe)' do
        sign_in alice
        recipe_params = attributes_for(:recipe, user: alice)
        post recipes_path, params: { recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice.recipes.last)
      end
    end
  end

  describe '#edit' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:alice_recipe) { create :recipe, :no_image, user: alice }

    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        get edit_recipe_path(alice_recipe)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in as wrong user' do
      it 'redirects to recipe_path(alice_recipe)' do
        sign_in bob
        get edit_recipe_path(alice_recipe)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end
    end

    context 'when signed in as correct user' do
      it 'returns a 200 response' do
        sign_in alice
        get edit_recipe_path(alice_recipe)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#update' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:alice_recipe) { create :recipe, :no_image, title: 'カレー', user: alice }

    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not update a recipe' do
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq 'カレー'
      end
    end

    context 'signed in as wrong user' do
      it 'redirects to recipe_path(alice_recipe)' do
        sign_in bob
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'does not update a recipe' do
        sign_in bob
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq 'カレー'
      end
    end

    context 'signed in as correct user and recipe_params[:recipe_image] is not present' do
      it 'redirects to recipe_path(alice_recipe)' do
        sign_in alice
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'updates a recipe' do
        sign_in alice
        recipe_params = attributes_for(:recipe, title: 'ラーメン')
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq 'ラーメン'
      end
    end

    context 'signed in as correct user and recipe_params[:recipe_image] is present' do
      let(:alice_recipe) { create :recipe, user: alice }

      it 'redirects to recipe_path(alice_recipe)' do
        sign_in alice
        recipe_image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/recipe_image_sample_after.jpg'))
        recipe_params = attributes_for(:recipe, recipe_image: recipe_image)
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'updates a recipe_image' do
        sign_in alice
        old_image_url = alice_recipe.recipe_image.url
        recipe_image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/recipe_image_sample_after.jpg'))
        recipe_params = attributes_for(:recipe, recipe_image: recipe_image)
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        new_image_url = alice_recipe.reload.recipe_image.url
        expect(new_image_url).to_not eq old_image_url
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let!(:alice_recipe) { create :recipe, :no_image, user: alice }

    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        delete recipe_path(alice_recipe)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not decrease Recipe count' do
        expect {
          delete recipe_path(alice_recipe)
        }.to change { Recipe.count }.by(0)
        .and change { alice.recipes.count }.by(0)
      end
    end

    context 'when signed in as wrong user' do
      it 'redirects to recipe_path(alice_recipe)' do
        sign_in bob
        delete recipe_path(alice_recipe)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'does not decrease Recipe count' do
        sign_in bob
        expect {
          delete recipe_path(alice_recipe)
        }.to change { Recipe.count }.by(0)
        .and change { alice.recipes.count }.by(0)
      end
    end

    context 'when signed in as correct user' do
      it 'redirects to recipes_path' do
        sign_in alice
        delete recipe_path(alice_recipe)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipes_path
      end

      it 'decreases Recipe count' do
        sign_in alice
        expect {
          delete recipe_path(alice_recipe)
        }.to change { Recipe.count }.by(-1)
        .and change { alice.recipes.count }.by(-1)
      end
    end
  end
end
