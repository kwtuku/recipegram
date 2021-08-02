require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe '#create' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }

    context 'when not signed in' do
      it 'does not increase Relationship count' do
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { Relationship.count }.by(0)
      end

      it 'does not increase User.followers count' do
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { bob.followers.count }.by(0)
      end

      it 'does not increase User.followings count' do
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { alice.followings.count }.by(0)
      end

      it 'returns a 401 response' do
        post relationships_path, params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'when signed in' do
      it 'increases Relationship count' do
        sign_in alice
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { Relationship.count }.by(1)
      end

      it 'increases User.followers count' do
        sign_in alice
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { bob.followers.count }.by(1)
      end

      it 'increases User.followings count' do
        sign_in alice
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { alice.followings.count }.by(1)
      end

      it 'returns a 200 response' do
        sign_in alice
        post relationships_path, params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    before do
      @relationship = alice.relationships.create(follow_id: bob.id)
    end

    context 'when not signed in' do
      it 'does not decrease Relationship count' do
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { Relationship.count }.by(0)
      end

      it 'does not decrease User.followers count' do
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { bob.followers.count }.by(0)
      end

      it 'does not decrease User.followings count' do
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { alice.followings.count }.by(0)
      end

      it 'returns a 401 response' do
        delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'when signed in' do
      it 'decreases Relationship count' do
        sign_in alice
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { Relationship.count }.by(-1)
      end

      it 'decreases User.followers count' do
        sign_in alice
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { bob.followers.count }.by(-1)
      end

      it 'decreases User.followings count' do
        sign_in alice
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { alice.followings.count }.by(-1)
      end

      it 'returns a 200 response' do
        sign_in alice
        delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end
end
