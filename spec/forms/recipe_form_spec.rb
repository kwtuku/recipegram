require 'rails_helper'

RSpec.describe RecipeForm, type: :model do
  def example_image_path
    format = %w[jpg jpeg png webp].sample
    Rails.root.join("spec/fixtures/#{format}_sample.#{format}")
  end

  def random_number
    SecureRandom.random_number(1 << 64)
  end

  describe '#save' do
    let(:alice) { create(:user) }

    context 'when new recipe with blank title' do
      let(:recipe_form) do
        attributes = attributes_for(:recipe, title: nil)
        described_class.new(attributes, recipe: alice.recipes.new)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of title blank' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:title, :blank)
      end

      it 'does not increase recipe count' do
        expect { recipe_form.save }.to change(Recipe, :count).by(0)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when new recipe with blank body' do
      let(:recipe_form) do
        attributes = attributes_for(:recipe, body: nil)
        described_class.new(attributes, recipe: alice.recipes.new)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of body blank' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:body, :blank)
      end

      it 'does not increase recipe count' do
        expect { recipe_form.save }.to change(Recipe, :count).by(0)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when new recipe with no images' do
      let(:recipe_form) do
        attributes = { **attributes_for(:recipe), image_attributes: nil }
        described_class.new(attributes, recipe: alice.recipes.new)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of require_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :require_images)
      end

      it 'does not increase recipe count' do
        expect { recipe_form.save }.to change(Recipe, :count).by(0)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when recipe is new and recipe and images are invalid' do
      let(:recipe_form) do
        attributes = attributes_for(:recipe, title: nil)
        described_class.new(attributes, recipe: alice.recipes.new)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has recipe error and image error' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:title, :blank)
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :require_images)
      end
    end

    context 'when a recipe exists with images and recipe and images are invalid' do
      let(:recipe_form) do
        existing_recipe = create(:recipe, :with_images, images_count: 1)
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        10.times do
          image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        end
        attributes = { **attributes_for(:recipe, body: nil), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has recipe error and image error' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:body, :blank)
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :too_many_images)
      end
    end

    context 'when new recipe with 1 image' do
      let(:recipe_form) do
        image_attributes = { Time.now.to_i.to_s => { 'resource' => Rack::Test::UploadedFile.new(example_image_path) } }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: alice.recipes.new)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'increases recipe count by 1' do
        expect { recipe_form.save }.to change(Recipe, :count).by(1)
      end

      it 'increases image count by 1' do
        expect { recipe_form.save }.to change(Image, :count).by(1)
      end
    end

    context 'when new recipe with 10 images' do
      let(:recipe_form) do
        image_attributes = Array.new(10) do
          [random_number, { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }]
        end.to_h
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: alice.recipes.new)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'increases recipe count by 1' do
        expect { recipe_form.save }.to change(Recipe, :count).by(1)
      end

      it 'increases image count by 10' do
        expect { recipe_form.save }.to change(Image, :count).by(10)
      end
    end

    context 'when new recipe with 11 images' do
      let(:recipe_form) do
        image_attributes = Array.new(11) do
          [random_number, { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }]
        end.to_h
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: alice.recipes.new)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of too_many_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :too_many_images)
      end

      it 'does not increase recipe count' do
        expect { recipe_form.save }.to change(Recipe, :count).by(0)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when a recipe exists with 1 image' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 1) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        attributes = { **attributes_for(:recipe, title: '新しいタイトル'), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'updates a recipe' do
        recipe_form.save
        expect(existing_recipe.reload.title).to eq '新しいタイトル'
      end
    end

    context 'when a recipe exists with 5 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 5) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.images.order(id: :desc).pluck(:id).each_with_index do |id, i|
          image_attributes[id]['position'] = i + 1
        end
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'changes image order' do
        recipe_form.save
        expect(recipe_form).to be_valid
        expect(existing_recipe.images.order(id: :desc).pluck(:position)).to eq [1, 2, 3, 4, 5]
      end
    end

    context 'when a recipe exists with 1 image and adding 1 image' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 1) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        image_attributes[Time.now.to_i.to_s] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'increases image count by 1' do
        expect { recipe_form.save }.to change(Image, :count).by(1)
      end
    end

    context 'when a recipe exists with 1 image and adding 9 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 1) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        9.times do
          image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        end
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'increases image count by 9' do
        expect { recipe_form.save }.to change(Image, :count).by(9)
      end
    end

    context 'when a recipe exists with 1 image and adding 10 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 1) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        10.times do
          image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        end
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of too_many_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :too_many_images)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when a recipe exists with 10 images and adding 1 image' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        image_attributes[Time.now.to_i.to_s] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of too_many_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :too_many_images)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when a recipe exists with 1 image and destroying 1 image' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 1) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        image_attributes[existing_recipe.image_ids.first]['_destroy'] = 'true'
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of require_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :require_images)
      end

      it 'does not decrease image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when a recipe exists with 10 images and destroying 1 image' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        image_attributes[existing_recipe.image_ids.sample]['_destroy'] = 'true'
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'decreases image count by -1' do
        expect { recipe_form.save }.to change(Image, :count).by(-1)
      end
    end

    context 'when a recipe exists with 10 images and destroying 9 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.image_ids.sample(9).each { |id| image_attributes[id]['_destroy'] = 'true' }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'decreases image count by -9' do
        expect { recipe_form.save }.to change(Image, :count).by(-9)
      end
    end

    context 'when a recipe exists with 10 images and destroying 10 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.image_ids.each { |id| image_attributes[id]['_destroy'] = 'true' }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of require_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :require_images)
      end

      it 'does not decrease image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when a recipe exists with 1 image and destroying 1 image and adding 1 image' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 1) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        image_attributes[existing_recipe.image_ids.first]['_destroy'] = 'true'
        image_attributes[Time.now.to_i.to_s] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'does not change image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end

      it 'changes image_ids' do
        destroying_image_ids = existing_recipe.image_ids
        recipe_form.save
        expect(existing_recipe.image_ids).not_to match_array destroying_image_ids
      end
    end

    context 'when a recipe exists with 1 image and destroying 1 image and adding 10 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 1) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        image_attributes[existing_recipe.image_ids.first]['_destroy'] = 'true'
        10.times do
          image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        end
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'changes image count from 1 to 10' do
        expect { recipe_form.save }.to change(Image, :count).from(1).to(10)
      end
    end

    context 'when a recipe exists with 1 image and destroying 1 image and adding 11 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 1) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        image_attributes[existing_recipe.image_ids.first]['_destroy'] = 'true'
        11.times do
          image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        end
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of too_many_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :too_many_images)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when a recipe exists with 10 images and destroying 9 images and adding 1 image' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.image_ids.sample(9).each { |id| image_attributes[id]['_destroy'] = 'true' }
        image_attributes[Time.now.to_i.to_s] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'changes image count from 10 to 2' do
        expect { recipe_form.save }.to change(Image, :count).from(10).to(2)
      end
    end

    context 'when a recipe exists with 10 images and destroying 9 images and adding 9 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.image_ids.sample(9).each { |id| image_attributes[id]['_destroy'] = 'true' }
        9.times { image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) } }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'does not change image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end

      it 'changes image_ids' do
        destroying_image_ids = existing_recipe.image_ids
        recipe_form.save
        expect(existing_recipe.image_ids).not_to match_array destroying_image_ids
      end
    end

    context 'when a recipe exists with 10 images and destroying 9 images and adding 10 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.image_ids.sample(9).each { |id| image_attributes[id]['_destroy'] = 'true' }
        10.times do
          image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        end
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of too_many_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :too_many_images)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end

    context 'when a recipe exists with 10 images and destroying 10 images and adding 1 image' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.image_ids.each { |id| image_attributes[id]['_destroy'] = 'true' }
        image_attributes[Time.now.to_i.to_s] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'changes image count from 10 to 1' do
        expect { recipe_form.save }.to change(Image, :count).from(10).to(1)
      end
    end

    context 'when a recipe exists with 10 images and destroying 10 images and adding 10 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.image_ids.each { |id| image_attributes[id]['_destroy'] = 'true' }
        10.times do
          image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        end
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns true' do
        expect(recipe_form.save).to be_truthy
      end

      it 'does not change image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end

      it 'changes image_ids' do
        destroying_image_ids = existing_recipe.image_ids
        recipe_form.save
        expect(existing_recipe.image_ids).not_to match_array destroying_image_ids
      end
    end

    context 'when a recipe exists with 10 images and destroying 10 images and adding 11 images' do
      let!(:existing_recipe) { create(:recipe, :with_images, images_count: 10) }
      let(:recipe_form) do
        image_attributes = described_class.new(recipe: existing_recipe).image_attributes
        existing_recipe.image_ids.each { |id| image_attributes[id]['_destroy'] = 'true' }
        11.times do
          image_attributes[random_number] = { 'resource' => Rack::Test::UploadedFile.new(example_image_path) }
        end
        attributes = { **attributes_for(:recipe), image_attributes: image_attributes }
        described_class.new(attributes, recipe: existing_recipe)
      end

      it 'returns false' do
        expect(recipe_form.save).to be_falsey
      end

      it 'has the error of too_many_images' do
        recipe_form.save
        expect(recipe_form.errors).to be_of_kind(:image_attributes, :too_many_images)
      end

      it 'does not increase image count' do
        expect { recipe_form.save }.to change(Image, :count).by(0)
      end
    end
  end
end
