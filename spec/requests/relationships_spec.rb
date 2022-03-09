require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe '#create' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }

    context 'when not signed in' do
      it 'returns a 401 response' do
        post relationships_path, params: { follow_id: bob.id }, xhr: true
        expect(response.status).to eq 401
      end

      it 'does not increase Relationship count' do
        expect do
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        end.to change(Relationship, :count).by(0)
          .and change(bob.followers, :count).by(0)
          .and change(alice.followings, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns a 200 response' do
        post relationships_path, params: { follow_id: bob.id }, xhr: true
        expect(response.status).to eq 200
      end

      it 'increases Relationship count' do
        expect do
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        end.to change(Relationship, :count).by(1)
          .and change(bob.followers, :count).by(1)
          .and change(alice.followings, :count).by(1)
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let!(:relationship) { alice.relationships.create(follow_id: bob.id) }

    context 'when not signed in' do
      it 'returns a 401 response' do
        delete relationship_path(relationship), params: { follow_id: bob.id }, xhr: true
        expect(response.status).to eq 401
      end

      it 'does not decrease Relationship count' do
        expect do
          delete relationship_path(relationship), params: { follow_id: bob.id }, xhr: true
        end.to change(Relationship, :count).by(0)
          .and change(bob.followers, :count).by(0)
          .and change(alice.followings, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns a 200 response' do
        delete relationship_path(relationship), params: { follow_id: bob.id }, xhr: true
        expect(response.status).to eq 200
      end

      it 'decreases Relationship count' do
        expect do
          delete relationship_path(relationship), params: { follow_id: bob.id }, xhr: true
        end.to change(Relationship, :count).by(-1)
          .and change(bob.followers, :count).by(-1)
          .and change(alice.followings, :count).by(-1)
      end
    end
  end
end
