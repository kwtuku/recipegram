require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'GET /tags' do
    context 'when not signed in' do
      it 'returns found' do
        get tags_path(name: '手軽')
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        get tags_path(name: '手軽')
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      let(:alice) { create(:user, :no_image) }

      before do
        create(:tag, name: '手軽')
        create(:tag, name: 'お手軽')
        create(:tag, name: 'かんたん')
        sign_in alice
      end

      it 'returns ok' do
        get tags_path(name: '手軽')
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct tag count' do
        get tags_path(name: '手軽')
        json = JSON.parse(response.body)
        expect(json['data'].length).to eq 2
      end
    end
  end

  describe 'GET /tags/:name' do
    let(:alice) { create(:user, :no_image) }
    let!(:tagged_recipe) { create(:recipe, :with_images, images_count: 1, tag_list: 'かんたん') }
    let!(:tag_kantan) { Tag.find_or_create_by(name: 'かんたん') }

    context 'when not signed in' do
      it 'returns ok' do
        get tag_path(tag_kantan.name)
        expect(response).to have_http_status(:ok)
      end

      it 'renders tagged recipes' do
        get tag_path(tag_kantan.name)
        expect(response.body).to include recipe_path(tagged_recipe)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        get tag_path(tag_kantan.name)
        expect(response).to have_http_status(:ok)
      end

      it 'renders tagged recipes' do
        get tag_path(tag_kantan.name)
        expect(response.body).to include recipe_path(tagged_recipe)
      end
    end
  end
end
