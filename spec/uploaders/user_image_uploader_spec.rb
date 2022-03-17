require 'rails_helper'

describe UserImageUploader do
  let(:user) { create(:user) }
  let(:uploader) { described_class.new(user, :user_image) }

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
        expect(public_id.split('/')[1]).to eq 'user'
      end
    end

    context 'when Rails.env is production' do
      it 'has correct public_id' do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
        public_id = uploader.public_id
        expect(public_id.split('/')[0]).to eq 'production'
        expect(public_id.split('/')[1]).to eq 'user'
      end
    end
  end

  describe 'store_dir' do
    it 'stores files in the correct directory' do
      expect(uploader.store_dir).to eq("uploads/user/user_image/#{user.id}")
    end
  end

  describe 'default_url' do
    it 'has a default image' do
      user = create(:user, user_image: '')
      expect(user.user_image.url).to eq '/images/default_user_image.jpg'
    end
  end

  describe 'formats' do
    it 'permits a set of extensions' do
      expect(uploader.extension_allowlist).to eq(%w[jpeg jpg png webp])
    end

    it 'permits jpeg' do
      image_jpeg = File.open(Rails.root.join('spec/fixtures/jpeg_sample.jpeg'))
      expect { uploader.store!(image_jpeg) }.not_to raise_error
    end

    it 'permits jpg' do
      image_jpg = File.open(Rails.root.join('spec/fixtures/jpg_sample.jpg'))
      expect { uploader.store!(image_jpg) }.not_to raise_error
    end

    it 'permits png' do
      image_png = File.open(Rails.root.join('spec/fixtures/png_sample.png'))
      expect { uploader.store!(image_png) }.not_to raise_error
    end

    it 'permits webp' do
      image_webp = File.open(Rails.root.join('spec/fixtures/webp_sample.webp'))
      expect { uploader.store!(image_webp) }.not_to raise_error
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
