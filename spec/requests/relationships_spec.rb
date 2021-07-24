require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe '#create' do
    let(:alice) { create :user }
    let(:bob) { create :user }

    context 'when not signed in' do
      it 'does not create relationship' do
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { Relationship.count }.by(0)
      end

      it 'does not create follower' do
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { bob.followers.count }.by(0)
      end

      it 'does not create following' do
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { alice.followings.count }.by(0)
      end

      it 'returns a 200 response' do
        sign_in alice
        post relationships_path, params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(200)
      end
    end

    context 'when signed in' do
      it 'creates relationship' do
        sign_in alice
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { Relationship.count }.by(1)
      end

      it 'creates follower' do
        sign_in alice
        expect {
          post relationships_path, params: { follow_id: bob.id }, xhr: true
        }.to change { bob.followers.count }.by(1)
      end

      it 'creates following' do
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
    let(:alice) { create :user }
    let(:bob) { create :user }
    before do
      @relationship = alice.relationships.create(follow_id: bob.id)
    end

    context 'when not signed in' do
      it 'does not destroy relationship' do
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { Relationship.count }.by(0)
      end

      it 'does not destroy follower' do
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { bob.followers.count }.by(0)
      end

      it 'does not destroy following' do
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { alice.followings.count }.by(0)
      end

      it 'returns a 200 response' do
        sign_in alice
        delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        expect(response).to have_http_status(200)
      end
    end

    context 'when signed in' do
      it 'destroys relationship' do
        sign_in alice
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { Relationship.count }.by(-1)
      end

      it 'destroys follower' do
        sign_in alice
        expect {
          delete relationship_path(@relationship), params: { follow_id: bob.id }, xhr: true
        }.to change { bob.followers.count }.by(-1)
      end

      it 'destroys following' do
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
