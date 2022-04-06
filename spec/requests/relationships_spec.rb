require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe 'POST /relationships' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }

    context 'when not signed in' do
      it 'returns unauthorized' do
        post relationships_path, params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not increase Relationship count' do
        expect do
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        end.to change(Relationship, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        post relationships_path, params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'increases Relationship count' do
        expect do
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        end.to change(Relationship, :count).by(1)
      end
    end
  end

  describe 'DELETE /relationships/:id' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }
    let!(:relationship) { alice.relationships.create(follow_id: bob.id) }

    context 'when not signed in' do
      it 'returns unauthorized' do
        delete relationship_path(relationship), params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not decrease Relationship count' do
        expect do
          delete relationship_path(relationship), params: { follow_id: bob.id }, xhr: true
        end.to change(Relationship, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns ok' do
        delete relationship_path(relationship), params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'decreases Relationship count' do
        expect do
          delete relationship_path(relationship), params: { follow_id: bob.id }, xhr: true
        end.to change(Relationship, :count).by(-1)
      end
    end
  end
end
