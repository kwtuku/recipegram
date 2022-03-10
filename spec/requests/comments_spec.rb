require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'POST /recipes/:recipe_id/comments' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:bob_recipe) { create(:recipe, :no_image, user: bob) }
    let(:comment_params) { attributes_for(:comment) }

    context 'when not signed in' do
      it 'returns found' do
        post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Comment count' do
        expect do
          post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        end.to change(Comment, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns found' do
        post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(commented recipe)' do
        post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        expect(response).to redirect_to recipe_path(bob_recipe)
      end

      it 'increases Comment count' do
        expect do
          post recipe_comments_path(bob_recipe), params: { comment: comment_params }
        end.to change(Comment, :count).by(1)
      end
    end
  end

  describe 'DELETE /recipes/:recipe_id/comments/:id' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:bob_recipe) { create(:recipe, :no_image, user: bob) }
    let!(:alice_comment) { create(:comment, user: alice, recipe: bob_recipe) }

    context 'when not signed in' do
      it 'returns found' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_path' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not decrease Comment count' do
        expect do
          delete recipe_comment_path(bob_recipe, alice_comment)
        end.to change(Comment, :count).by(0)
      end
    end

    context 'when user is not the author' do
      before { sign_in bob }

      it 'returns found' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to request.referer or root_path' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to redirect_to(request.referer || root_path)
      end

      it 'has the flash message' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(flash[:alert]).to eq '権限がありません。'
      end

      it 'does not decrease Comment count' do
        expect do
          delete recipe_comment_path(bob_recipe, alice_comment)
        end.to change(Comment, :count).by(0)
      end
    end

    context 'when user is the author' do
      before { sign_in alice }

      it 'returns found' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to have_http_status(:found)
      end

      it 'redirects to recipe_path(commented recipe)' do
        delete recipe_comment_path(bob_recipe, alice_comment)
        expect(response).to redirect_to recipe_path(bob_recipe)
      end

      it 'decreases Comment count' do
        expect do
          delete recipe_comment_path(bob_recipe, alice_comment)
        end.to change(Comment, :count).by(-1)
      end
    end
  end
end
