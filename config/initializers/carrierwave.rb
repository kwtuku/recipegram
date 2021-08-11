CarrierWave.configure do |config|
  config.enable_processing = false if Rails.env.test?
end
