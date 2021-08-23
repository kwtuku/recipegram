require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe '#create' do
    let(:alice) { create :user, :no_image }
    let(:alice_recipe) { create :recipe, :no_image, user: alice }

    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        comment_params = attributes_for(:comment)
        post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Comment count' do
        comment_params = attributes_for(:comment)
        expect {
          post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        }.to change { Comment.count }.by(0)
      end
    end

    context 'when signed in' do
      it 'redirects to recipe_path(commented recipe)' do
        sign_in alice
        comment_params = attributes_for(:comment)
        post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'increases Comment count' do
        sign_in alice
        comment_params = attributes_for(:comment)
        expect {
          post recipe_comments_path(alice_recipe), params: { comment: comment_params }
        }.to change { Comment.count }.by(1)
        .and change { alice.comments.count }.by(1)
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:alice_recipe) { create :recipe, :no_image, user: alice }
    let!(:alice_comment) { create :comment, user: alice, recipe: alice_recipe }

    context 'when not signed in' do
      it 'redirects to new_user_session_path' do
        get recipe_path(alice_recipe)
        delete recipe_comment_path(alice_comment)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not decrease Comment count' do
        expect {
          get recipe_path(alice_recipe)
          delete recipe_comment_path(alice_comment)
        }.to change { Comment.count }.by(0)
        .and change { alice.comments.count }.by(0)
      end
    end

    context 'when signed in as wrong user' do
      it 'redirects to recipe_path(commented recipe)' do
        sign_in bob
        get recipe_path(alice_recipe)
        delete recipe_comment_path(alice_comment)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'does not decrease Comment count' do
        sign_in bob
        expect {
          get recipe_path(alice_recipe)
          delete recipe_comment_path(alice_comment)
        }.to change { Comment.count }.by(0)
        .and change { alice.comments.count }.by(0)
      end
    end

    context 'when signed in as correct user' do
      it 'redirects to recipe_path(commented recipe)' do
        sign_in alice
        get recipe_path(alice_recipe)
        delete recipe_comment_path(alice_comment)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to recipe_path(alice_recipe)
      end

      it 'does not decrease Comment count' do
        sign_in alice
        expect {
          get recipe_path(alice_recipe)
          delete recipe_comment_path(alice_comment)
        }.to change { Comment.count }.by(-1)
        .and change { alice.comments.count }.by(-1)
      end
    end
  end
end
