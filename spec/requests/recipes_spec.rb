require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe '#index' do
    before do
      users = create_list(:user, 5, :no_image)
      users.each do |user|
        create(:recipe, :no_image, user: user)
      end
    end

    let(:alice) { create(:user, :no_image) }

    it 'returns ok when not signed in' do
      get recipes_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns ok when signed in' do
      sign_in alice
      get recipes_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:bob_recipe) { create(:recipe, :no_image, user: bob) }

    context 'when not signed in and other recipes exist' do
      before { create_list(:recipe, 4, :no_image, user: bob) }

      it 'returns ok' do
        get recipe_path(bob_recipe)
        expect(response).to have_http_status(:ok)
      end

      it 'renders other recipe link' do
        get recipe_path(bob_recipe)
        expect(response.body).to include "/recipes/#{bob_recipe.others(3).sample.id}"
      end
    end

    context 'when not signed in and other recipes do not exist' do
      it 'returns ok' do
        get recipe_path(bob_recipe)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when signed in and other recipes exist' do
      before do
        create_list(:recipe, 4, :no_image, user: bob)
        sign_in alice
      end

      it 'returns ok' do
        get recipe_path(bob_recipe)
        expect(response).to have_http_status(:ok)
      end

      it 'renders other recipe link' do
        get recipe_path(bob_recipe)
        expect(response.body).to include "/recipes/#{bob_recipe.others(3).sample.id}"
      end
    end

    context 'when signed in and other recipes do not exist' do
      it 'returns ok' do
        sign_in alice
        get recipe_path(bob_recipe)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#new' do
    let(:alice) { create(:user, :no_image) }

    context 'when not signed in' do
      it 'returns found' do
        get new_recipe_path
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get new_recipe_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      it 'returns ok' do
        sign_in alice
        get new_recipe_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#create' do
    let(:alice) { create(:user, :no_image) }
    let(:recipe_params) { attributes_for(:recipe) }

    context 'when not signed in' do
      it 'returns found' do
        post recipes_path, params: { recipe: recipe_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        post recipes_path, params: { recipe: recipe_params }
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Recipe count' do
        expect do
          post recipes_path, params: { recipe: recipe_params }
        end.to change(Recipe, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns found' do
        post recipes_path, params: { recipe: recipe_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(new_recipe)' do
        post recipes_path, params: { recipe: recipe_params }
        expect(response).to redirect_to recipe_path(alice.recipes.last)
      end

      it 'increases Recipe count' do
        expect do
          post recipes_path, params: { recipe: recipe_params }
        end.to change(Recipe, :count).by(1)
      end
    end
  end

  describe '#edit' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:alice_recipe) { create(:recipe, :no_image, user: alice) }

    context 'when not signed in' do
      it 'returns found' do
        get edit_recipe_path(alice_recipe)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get edit_recipe_path(alice_recipe)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user is not the author' do
      before { sign_in bob }

      it 'returns found' do
        get edit_recipe_path(alice_recipe)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to request.referer or root_path' do
        get edit_recipe_path(alice_recipe)
        expect(response).to redirect_to(request.referer || root_path)
      end

      it 'has the flash message' do
        get edit_recipe_path(alice_recipe)
        expect(flash[:alert]).to eq '権限がありません。'
      end
    end

    context 'when user is the author' do
      it 'returns ok' do
        sign_in alice
        get edit_recipe_path(alice_recipe)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#update' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:alice_recipe) { create(:recipe, title: 'カレー', user: alice) }
    let(:recipe_params) { { title: 'ラーメン' } }

    context 'when not signed in' do
      it 'returns found' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not update a recipe' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq 'カレー'
      end
    end

    context 'when user is not the author' do
      before { sign_in bob }

      it 'returns found' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to request.referer or root_path' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to redirect_to(request.referer || root_path)
      end

      it 'has the flash message' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(flash[:alert]).to eq '権限がありません。'
      end

      it 'does not update a recipe' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq 'カレー'
      end
    end

    context 'when user is the author and recipe_params[:recipe_image] is not present' do
      before { sign_in alice }

      it 'returns found' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(alice_recipe)' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'updates a recipe' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params }
        expect(alice_recipe.reload.title).to eq 'ラーメン'
      end
    end

    context 'when user is the author and recipe_params[:recipe_image] is present' do
      let(:recipe_params_with_image) do
        new_recipe_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/recipe_image_sample_after.jpg'))
        { recipe_image: new_recipe_image }
      end

      before { sign_in alice }

      it 'returns found' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params_with_image }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(alice_recipe)' do
        patch recipe_path(alice_recipe), params: { recipe: recipe_params_with_image }
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'updates a recipe_image' do
        old_image_url = alice_recipe.recipe_image.url
        patch recipe_path(alice_recipe), params: { recipe: recipe_params_with_image }
        new_image_url = alice_recipe.reload.recipe_image.url
        expect(new_image_url).not_to eq old_image_url
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let!(:alice_recipe) { create(:recipe, :no_image, user: alice) }

    context 'when not signed in' do
      it 'returns found' do
        delete recipe_path(alice_recipe)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        delete recipe_path(alice_recipe)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not decrease Recipe count' do
        expect do
          delete recipe_path(alice_recipe)
        end.to change(Recipe, :count).by(0)
      end
    end

    context 'when user is not the author' do
      before { sign_in bob }

      it 'returns found' do
        delete recipe_path(alice_recipe)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to request.referer or root_path' do
        delete recipe_path(alice_recipe)
        expect(response).to redirect_to(request.referer || root_path)
      end

      it 'has the flash message' do
        delete recipe_path(alice_recipe)
        expect(flash[:alert]).to eq '権限がありません。'
      end

      it 'does not decrease Recipe count' do
        expect do
          delete recipe_path(alice_recipe)
        end.to change(Recipe, :count).by(0)
      end
    end

    context 'when user is the author' do
      before { sign_in alice }

      it 'returns found' do
        delete recipe_path(alice_recipe)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipes_path' do
        delete recipe_path(alice_recipe)
        expect(response).to redirect_to recipes_path
      end

      it 'decreases Recipe count' do
        expect do
          delete recipe_path(alice_recipe)
        end.to change(Recipe, :count).by(-1)
      end
    end
  end
end
