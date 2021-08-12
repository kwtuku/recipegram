require 'rails_helper'
require 'carrierwave/test/matchers'

describe UserImageUploader do
  include CarrierWave::Test::Matchers

  let(:user) { create :user }
  let(:uploader) { UserImageUploader.new(user, :user_image) }

  before do
    UserImageUploader.enable_processing = true
    File.open(File.join(Rails.root, 'spec/fixtures/user_image_sample.jpg')) { |f| uploader.store!(f) }
  end

  after do
    UserImageUploader.enable_processing = false
    uploader.remove!
  end

  it 'stores files in the correct directory' do
    expect(uploader.store_dir).to eq("uploads/user/user_image/#{user.id}")
  end

  it 'rejects images over 2MB' do
    image_over_2mb = File.open(File.join(Rails.root, 'spec/fixtures/over_2mb.jpg'))
    expect { uploader.store!(image_over_2mb) }.to raise_error(CarrierWave::IntegrityError)
  end

  describe 'formats' do
    it 'permits a set of extensions' do
      extensions = %w(jpeg jpg png webp)
      expect(uploader.extension_allowlist).to eq(extensions)
    end

    it 'permits jpegs' do
      image_jpeg = File.open(File.join(Rails.root, 'spec/fixtures/jpeg_sample.jpeg'))
      uploader.store!(image_jpeg)
      expect(uploader).to be_format('jpeg')
    end

    it 'permits jpgs' do
      image_jpg = File.open(File.join(Rails.root, 'spec/fixtures/jpg_sample.jpg'))
      uploader.store!(image_jpg)
      expect(uploader).to be_format('jpeg')
    end

    it 'permits pngs' do
      image_png = File.open(File.join(Rails.root, 'spec/fixtures/png_sample.png'))
      uploader.store!(image_png)
      expect(uploader).to be_format('png')
    end

    it 'permits webps' do
      image_webp = File.open(File.join(Rails.root, 'spec/fixtures/webp_sample.webp'))
      uploader.store!(image_webp)
      expect(uploader).to be_format('webp')
    end

    it 'rejects unsupported formats like gif' do
      image_gif = File.open(File.join(Rails.root, 'spec/fixtures/gif_sample.gif'))
      expect { uploader.store!(image_gif) }.to raise_error(CarrierWave::IntegrityError)
    end
  end

  describe 'versions' do
    context 'the icon version' do
      it 'scales down a image to fit within 150 by 150 pixels' do
        expect(uploader.icon).to be_no_larger_than(150, 150)
      end
    end

    context 'the thumb version' do
      it 'scales down a image to be exactly 320 by 320 pixels' do
        expect(uploader.thumb).to have_dimensions(320, 320)
      end
    end
  end
end
