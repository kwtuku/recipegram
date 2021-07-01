require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'POST /recipes/:recipe_id/comments' do
    let(:alice) { create :user }
    let(:alice_recipe) { create :recipe, user: alice }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        comment_params = attributes_for(:comment)
        expect {
          post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        }.to change { Comment.count }.by(0)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in' do
      it 'create comment' do
        sign_in alice
        comment_params = attributes_for(:comment)
        expect {
          post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        }.to change { alice.comments.count }.by(1)
      end
    end
  end

  describe 'DELETE /recipes/:recipe_id/comments/:id' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:alice_recipe) { create :recipe, user: alice }
    let!(:alice_comment) { create :comment, user: alice, recipe: alice_recipe }

    context 'not signed in' do
      it 'redirect_to new_user_session_path' do
        expect {
          get recipe_path(alice_recipe)
          delete recipe_comment_path(alice_comment)
        }.to change { alice.comments.count }.by(0)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in as wrong user' do
      it 'can not destroy other user comment' do
        sign_in bob
        expect {
          get recipe_path(alice_recipe)
          delete recipe_comment_path(alice_comment)
        }.to change { alice.comments.count }.by(0)
      end
    end

    context 'signed in as correct user' do
      it 'destroy comment' do
        sign_in alice
        expect {
          get recipe_path(alice_recipe)
          delete recipe_comment_path(alice_comment)
        }.to change { alice.comments.count }.by(-1)
      end
    end
  end
end
