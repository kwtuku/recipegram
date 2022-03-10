require 'rails_helper'
require 'carrierwave/test/matchers'

describe RecipeImageUploader do
  include CarrierWave::Test::Matchers

  let(:recipe) { create(:recipe) }
  let(:uploader) { described_class.new(recipe, :recipe_image) }

  before do
    described_class.enable_processing = true
  end

  after do
    described_class.enable_processing = false
    uploader.remove!
  end

  describe 'public_id' do
    context 'when Rails.env is development' do
      it 'has correct public_id' do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
        public_id = uploader.public_id
        expect(public_id.split('/')[0]).to eq 'development'
        expect(public_id.split('/')[1]).to eq 'recipe'
      end
    end

    context 'when Rails.env is production' do
      it 'has correct public_id' do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
        public_id = uploader.public_id
        expect(public_id.split('/')[0]).to eq 'production'
        expect(public_id.split('/')[1]).to eq 'recipe'
      end
    end
  end

  describe 'store_dir' do
    it 'stores files in the correct directory' do
      expect(uploader.store_dir).to eq("uploads/recipe/recipe_image/#{recipe.id}")
    end
  end

  describe 'versions' do
    before do
      image = File.open(Rails.root.join('spec/fixtures/recipe_image_sample.jpg'))
      uploader.store!(image)
    end

    describe 'the thumb version' do
      it 'scales down a image to be exactly 640 by 640 pixels' do
        expect(uploader.thumb).to have_dimensions(640, 640)
      end
    end

    describe 'the main version' do
      it 'scales down a image to fit within 1200 by 1200 pixels' do
        expect(uploader.main).to be_no_larger_than(1200, 1200)
      end
    end
  end

  describe 'extension_allowlist' do
    it 'permits a set of extensions' do
      extensions = %w[jpeg jpg png webp]
      expect(uploader.extension_allowlist).to eq(extensions)
    end

    it 'permits jpegs' do
      image_jpeg = File.open(Rails.root.join('spec/fixtures/jpeg_sample.jpeg'))
      uploader.store!(image_jpeg)
      expect(uploader).to be_format('jpeg')
    end

    it 'permits jpgs' do
      image_jpg = File.open(Rails.root.join('spec/fixtures/jpg_sample.jpg'))
      uploader.store!(image_jpg)
      expect(uploader).to be_format('jpeg')
    end

    it 'permits pngs' do
      image_png = File.open(Rails.root.join('spec/fixtures/png_sample.png'))
      uploader.store!(image_png)
      expect(uploader).to be_format('png')
    end

    it 'permits webps' do
      image_webp = File.open(Rails.root.join('spec/fixtures/webp_sample.webp'))
      uploader.store!(image_webp)
      expect(uploader).to be_format('webp')
    end

    it 'rejects unsupported formats like gif' do
      image_gif = File.open(Rails.root.join('spec/fixtures/gif_sample.gif'))
      expect { uploader.store!(image_gif) }.to raise_error(CarrierWave::IntegrityError)
    end
  end

  describe 'size_range' do
    it 'rejects images over 2MB' do
      image_over_2mb = File.open(Rails.root.join('spec/fixtures/over_2mb.jpg'))
      expect { uploader.store!(image_over_2mb) }.to raise_error(CarrierWave::IntegrityError)
    end
  end
end
