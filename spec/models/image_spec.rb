require 'rails_helper'

RSpec.describe Image, type: :model do
  it { expect(build_stubbed(:image)).to validate_presence_of(:resource) }

  describe 'validate_max_images_count' do
    context 'when a recipe has 9 images' do
      it 'is valid' do
        image = build_stubbed(:image, recipe: create(:recipe, :with_images, images_count: 9))
        expect(image).to be_valid
      end
    end

    context 'when a recipe has 10 images' do
      it 'is invalid' do
        image = create(:recipe, :with_images, images_count: 10).images.new(**attributes_for(:image))
        expect(image).to be_invalid
        expect(image.errors).to be_of_kind(:base, :too_many_images)
      end
    end
  end

  describe 'validate_min_images_count' do
    context 'when a recipe has 1 image' do
      let!(:image) { create(:image) }

      it 'does not decrease image count' do
        expect { image.destroy }.to change(described_class, :count).by(0)
      end

      it 'has the error of require_images' do
        image.destroy
        expect(image.errors).to be_of_kind(:base, :require_images)
      end
    end

    context 'when a recipe has 2 images' do
      it 'decreases image count' do
        image = create(:recipe, :with_images, images_count: 2).images.first
        expect { image.destroy }.to change(described_class, :count).by(-1)
      end
    end

    context 'when destroying a recipe with 1 image' do
      let!(:recipe) { create(:recipe, :with_images, images_count: 1) }

      it 'decreases recipe count' do
        expect { recipe.destroy }.to change(Recipe, :count).by(-1)
      end

      it 'decreases image count' do
        expect { recipe.destroy }.to change(described_class, :count).by(-1)
      end
    end

    context 'when destroying a recipe with 2 images' do
      let!(:recipe) { create(:recipe, :with_images, images_count: 2) }

      it 'decreases recipe count' do
        expect { recipe.destroy }.to change(Recipe, :count).by(-1)
      end

      it 'decreases image count' do
        expect { recipe.destroy }.to change(described_class, :count).by(-2)
      end
    end
  end
end
