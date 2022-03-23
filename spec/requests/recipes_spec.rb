require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  def example_image_path
    format = %w[jpg jpeg png webp].sample
    Rails.root.join("spec/fixtures/#{format}_sample.#{format}")
  end

  describe 'GET /recipes' do
    before do
      users = create_list(:user, 5, :no_image)
      users.each do |user|
        create(:recipe, :with_images, images_count: 1, user: user)
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

  describe 'GET /recipes/:id' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:bob_recipe) { create(:recipe, :with_images, images_count: 1, user: bob) }

    context 'when not signed in and other recipes exist' do
      before { create_list(:recipe, 4, :with_images, images_count: 1, user: bob) }

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
        create_list(:recipe, 4, :with_images, images_count: 1, user: bob)
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

  describe 'GET /recipes/new' do
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

  describe 'POST /recipes' do
    let(:alice) { create(:user, :no_image) }

    context 'when not signed in' do
      let(:params) do
        image_attributes = { Time.now.to_i.to_s => { 'resource' => Rack::Test::UploadedFile.new(example_image_path) } }
        { recipe: { **attributes_for(:recipe), image_attributes: image_attributes } }
      end

      it 'returns found' do
        post recipes_path, params: params
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        post recipes_path, params: params
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Recipe count' do
        expect do
          post recipes_path, params: params
        end.to change(Recipe, :count).by(0)
      end

      it 'does not increase Image count' do
        expect do
          post recipes_path, params: params
        end.to change(Image, :count).by(0)
      end
    end

    context 'when signed in and params has title, body and 1 resource' do
      let(:params) do
        image_attributes = { Time.now.to_i.to_s => { 'resource' => Rack::Test::UploadedFile.new(example_image_path) } }
        { recipe: { **attributes_for(:recipe), image_attributes: image_attributes } }
      end

      before { sign_in alice }

      it 'returns found' do
        post recipes_path, params: params
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(new_recipe)' do
        post recipes_path, params: params
        expect(response).to redirect_to recipe_path(alice.recipes.last)
      end

      it 'increases Recipe count by 1' do
        expect do
          post recipes_path, params: params
        end.to change(Recipe, :count).by(1)
      end

      it 'increases Image count by 1' do
        expect do
          post recipes_path, params: params
        end.to change(Image, :count).by(1)
      end
    end

    context 'when signed in and params has title, body and 10 resources' do
      let(:params) do
        image_attributes = Array.new(10) do
          [SecureRandom.random_number(1 << 64), { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }]
        end.to_h
        { recipe: { **attributes_for(:recipe), image_attributes: image_attributes } }
      end

      before { sign_in alice }

      it 'returns found' do
        post recipes_path, params: params
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(new_recipe)' do
        post recipes_path, params: params
        expect(response).to redirect_to recipe_path(alice.recipes.last)
      end

      it 'increases Recipe count by 1' do
        expect do
          post recipes_path, params: params
        end.to change(Recipe, :count).by(1)
      end

      it 'increases Image count by 10' do
        expect do
          post recipes_path, params: params
        end.to change(Image, :count).by(10)
      end
    end
  end

  describe 'GET /recipes/:id/edit' do
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

  describe 'PATCH /recipes/:id' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let!(:alice_recipe) { create(:recipe, :with_images, images_count: 1, title: 'カレー', user: alice) }

    context 'when not signed in' do
      let(:params) do
        image_attributes = { Time.now.to_i.to_s => { 'resource' => Rack::Test::UploadedFile.new(example_image_path) } }
        { recipe: { **attributes_for(:recipe, title: 'ラーメン'), image_attributes: image_attributes } }
      end

      it 'returns found' do
        patch recipe_path(alice_recipe), params: params
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        patch recipe_path(alice_recipe), params: params
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not update a recipe' do
        patch recipe_path(alice_recipe), params: params
        expect(alice_recipe.reload.title).to eq 'カレー'
      end
    end

    context 'when user is not the author' do
      let(:params) do
        image_attributes = { Time.now.to_i.to_s => { 'resource' => Rack::Test::UploadedFile.new(example_image_path) } }
        { recipe: { **attributes_for(:recipe, title: 'ラーメン'), image_attributes: image_attributes } }
      end

      before { sign_in bob }

      it 'returns found' do
        patch recipe_path(alice_recipe), params: params
        expect(response).to have_http_status(:found)
      end

      it 'redirects to request.referer or root_path' do
        patch recipe_path(alice_recipe), params: params
        expect(response).to redirect_to(request.referer || root_path)
      end

      it 'has the flash message' do
        patch recipe_path(alice_recipe), params: params
        expect(flash[:alert]).to eq '権限がありません。'
      end

      it 'does not update a recipe' do
        patch recipe_path(alice_recipe), params: params
        expect(alice_recipe.reload.title).to eq 'カレー'
      end

      it 'does not increase Image count' do
        expect do
          patch recipe_path(alice_recipe), params: params
        end.to change(Image, :count).by(0)
      end
    end

    context 'when user is the author and params has title, body and new 1 resource' do
      let(:params) do
        image_attributes = { Time.now.to_i.to_s => { 'resource' => Rack::Test::UploadedFile.new(example_image_path) } }
        { recipe: { **attributes_for(:recipe, title: 'ラーメン'), image_attributes: image_attributes } }
      end

      before { sign_in alice }

      it 'returns found' do
        patch recipe_path(alice_recipe), params: params
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(alice_recipe)' do
        patch recipe_path(alice_recipe), params: params
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'updates a title' do
        patch recipe_path(alice_recipe), params: params
        expect(alice_recipe.reload.title).to eq 'ラーメン'
      end

      it 'increases Image count by 1' do
        expect do
          patch recipe_path(alice_recipe), params: params
        end.to change(Image, :count).by(1)
      end
    end

    context 'when user is the author and params has title, body and new 9 resource' do
      let(:params) do
        image_attributes = Array.new(9) do
          [SecureRandom.random_number(1 << 64), { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }]
        end.to_h
        { recipe: { **attributes_for(:recipe), image_attributes: image_attributes } }
      end

      before { sign_in alice }

      it 'returns found' do
        patch recipe_path(alice_recipe), params: params
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(alice_recipe)' do
        patch recipe_path(alice_recipe), params: params
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'increases Image count by 9' do
        expect do
          patch recipe_path(alice_recipe), params: params
        end.to change(Image, :count).by(9)
      end
    end
  end

  describe 'DELETE /recipes/:id' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let!(:alice_recipe) { create(:recipe, :with_images, images_count: 1, user: alice) }

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
