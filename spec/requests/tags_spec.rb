require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe '#index' do
    context 'when not signed in' do
      it 'returns a 302 response' do
        get tags_path(name: '手軽')
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        get tags_path(name: '手軽')
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      let(:alice) { create :user, :no_image }

      before do
        create :tag, name: '手軽'
        create :tag, name: 'お手軽'
        create :tag, name: 'かんたん'
        sign_in alice
      end

      it 'returns a 200 response' do
        get tags_path(name: '手軽')
        expect(response.status).to eq 200
      end

      it 'returns correct tag count' do
        get tags_path(name: '手軽')
        json = JSON.parse(response.body)
        expect(json['data'].length).to eq 2
      end
    end
  end

  describe '#show' do
    let(:alice) { create :user, :no_image }
    let!(:tagged_recipe) { create :recipe, :no_image, tag_list: 'かんたん' }
    let!(:tag_kantan) { Tag.find_or_create_by(name: 'かんたん') }

    context 'when not signed in' do
      it 'returns a 200 response' do
        get tag_path(tag_kantan.name)
        expect(response.status).to eq 200
      end

      it 'renders tagged recipes' do
        get tag_path(tag_kantan.name)
        expect(response.body).to include recipe_path(tagged_recipe)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns a 200 response' do
        get tag_path(tag_kantan.name)
        expect(response.status).to eq 200
      end

      it 'renders tagged recipes' do
        get tag_path(tag_kantan.name)
        expect(response.body).to include recipe_path(tagged_recipe)
      end
    end

    context 'when a tag is nil' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          get tag_path(SecureRandom.urlsafe_base64)
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
