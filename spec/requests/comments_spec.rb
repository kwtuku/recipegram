require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe '#create' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:bob_recipe) { create :recipe, :no_image, user: bob }
    let(:comment_params) { attributes_for(:comment) }

    context 'when not signed in' do
      it 'returns a 302 response' do
        post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Comment count' do
        expect do
          post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        end.to change(Comment, :count).by(0)
          .and change(bob_recipe.comments, :count).by(0)
          .and change(alice.comments, :count).by(0)
          .and change(alice.commented_recipes, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns a 302 response' do
        post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        expect(response.status).to eq 302
      end

      it 'redirects to recipe_path(commented recipe)' do
        post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        expect(response).to redirect_to recipe_path(bob_recipe)
      end

      it 'increases Comment count' do
        expect do
          post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        end.to change(Comment, :count).by(1)
          .and change(bob_recipe.comments, :count).by(1)
          .and change(alice.comments, :count).by(1)
          .and change(alice.commented_recipes, :count).by(1)
      end
    end
  end

  describe '#destroy' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let(:bob_recipe) { create :recipe, :no_image, user: bob }
    let!(:alice_comment) { create :comment, user: alice, recipe: bob_recipe }

    context 'when not signed in' do
      it 'returns a 302 response' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not decrease Comment count' do
        expect do
          delete recipe_comment_path(bob_recipe, alice_comment)
        end.to change(Comment, :count).by(0)
          .and change(bob_recipe.comments, :count).by(0)
          .and change(alice.comments, :count).by(0)
          .and change(alice.commented_recipes, :count).by(0)
      end
    end

    context 'when signed in as wrong user' do
      before { sign_in bob }

      it 'returns a 302 response' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response.status).to eq 302
      end

      it 'redirects to recipe_path(commented recipe)' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to redirect_to recipe_path(bob_recipe)
      end

      it 'does not decrease Comment count' do
        expect do
          delete recipe_comment_path(bob_recipe, alice_comment)
        end.to change(Comment, :count).by(0)
          .and change(bob_recipe.comments, :count).by(0)
          .and change(alice.comments, :count).by(0)
          .and change(alice.commented_recipes, :count).by(0)
      end
    end

    context 'when signed in as correct user' do
      before { sign_in alice }

      it 'returns a 302 response' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response.status).to eq 302
      end

      it 'redirects to recipe_path(commented recipe)' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to redirect_to recipe_path(bob_recipe)
      end

      it 'decreases Comment count' do
        expect do
          delete recipe_comment_path(bob_recipe, alice_comment)
        end.to change(Comment, :count).by(-1)
          .and change(bob_recipe.comments, :count).by(-1)
          .and change(alice.comments, :count).by(-1)
          .and change(alice.commented_recipes, :count).by(-1)
      end
    end
  end
end
