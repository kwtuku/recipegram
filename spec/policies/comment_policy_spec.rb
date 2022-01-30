require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:alice) { create(:user, :no_image) }
  let(:bob) { create(:user, :no_image) }
  let(:alice_comment) { create(:comment, recipe: create(:recipe, :no_image, user: bob), user: alice) }

  permissions :destroy? do
    context 'when user is the author' do
      it 'grants access' do
        expect(described_class).to permit(alice, alice_comment)
      end
    end

    context 'when user is not the author' do
      it 'denies access' do
        expect(described_class).not_to permit(bob, alice_comment)
      end
    end
  end
end
