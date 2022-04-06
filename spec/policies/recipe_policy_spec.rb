require 'rails_helper'

RSpec.describe RecipePolicy, type: :policy do
  let(:alice) { create(:user) }
  let(:bob) { create(:user) }
  let(:alice_recipe) { create(:recipe, user: alice) }

  permissions :update?, :edit?, :destroy? do
    context 'when user is the author' do
      it 'grants access' do
        expect(described_class).to permit(alice, alice_recipe)
      end
    end

    context 'when user is not the author' do
      it 'denies access' do
        expect(described_class).not_to permit(bob, alice_recipe)
      end
    end
  end
end
