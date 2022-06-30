source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'rails', '6.1.6'

gem 'bootsnap', require: false
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'turbolinks'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker'

gem 'acts-as-taggable-on'
gem 'carrierwave'
gem 'cloudinary'
gem 'counter_culture'
gem 'devise'
gem 'devise-i18n'
gem 'faker'
gem 'kaminari'
gem 'pundit'
gem 'rails-i18n'
gem 'ransack'
gem 'redis'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen'
  gem 'rack-mini-profiler'
  gem 'spring'
  gem 'web-console'

  gem 'brakeman', require: false
  gem 'bullet'
  gem 'erb_lint', require: false
  gem 'rails_best_practices', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
