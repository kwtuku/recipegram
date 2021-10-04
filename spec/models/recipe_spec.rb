require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(30) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(2000) }
    it { is_expected.to validate_presence_of(:recipe_image) }
  end

  describe 'others(count)' do
    let(:alice) { create :user, :no_image }
    let(:bob) { create :user, :no_image }
    let!(:curry) { create :recipe, :no_image, user: alice }
    let!(:gratin) { create :recipe, :no_image, user: alice }
    let!(:pizza) { create :recipe, :no_image, user: alice }
    let!(:ramen) { create :recipe, :no_image, user: alice }
    let!(:steak) { create :recipe, :no_image, user: alice }
    let!(:kebab) { create :recipe, :no_image, user: alice }
    let!(:salad) { create :recipe, :no_image, user: bob }

    it 'does not have irrelevant recipe' do
      expect(pizza.others(3)).not_to include salad
    end

    it 'does not have self' do
      expect(pizza.others(3)).not_to include pizza
    end

    context 'when second recipe in descending order of id' do
      it 'has correct recipes' do
        alice_recipe_ids = alice.recipes.ids.sort.reverse
        third_recipe = described_class.find(alice_recipe_ids[1])
        expect(third_recipe.others(3)[0].id).to eq alice_recipe_ids[0]
        expect(third_recipe.others(3)[1].id).to eq alice_recipe_ids[2]
        expect(third_recipe.others(3)[2].id).to eq alice_recipe_ids[3]
      end
    end

    context 'when fifth recipe in descending order of id' do
      it 'has correct recipes' do
        alice_recipe_ids = alice.recipes.ids.sort.reverse
        third_recipe = described_class.find(alice_recipe_ids[4])
        expect(third_recipe.others(3)[0].id).to eq alice_recipe_ids[0]
        expect(third_recipe.others(3)[1].id).to eq alice_recipe_ids[1]
        expect(third_recipe.others(3)[2].id).to eq alice_recipe_ids[2]
      end
    end

    context 'when other recipe does not exist' do
      it 'has no recipe' do
        expect(salad.others(3)).to eq []
      end
    end
  end
end
