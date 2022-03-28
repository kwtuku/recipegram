namespace :coverage do
  desc 'Collates all result sets generated by the different test runners'
  task report: :environment do
    require 'simplecov'

    SimpleCov.collate Dir['/tmp/coverage/.resultset-*.json'], 'rails'
  end
end
