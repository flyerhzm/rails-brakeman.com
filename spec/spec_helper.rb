require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'webmock/rspec'
  require 'email_spec'
  require 'simplecov'
  require 'mocha/setup'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'shoulda/matchers'

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  Devise.stretches = 1
  Rails.logger.level = 4

  SimpleCov.start 'rails'

  RSpec.configure do |config|
    config.mock_with :mocha

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    config.use_transactional_fixtures = true

    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run :focus

    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)
    config.include Support::BuildHelper
    config.include Support::ControllerHelper
    config.include Support::DelayedJobHelper
    config.include Support::CallbackHelper

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  require 'factory_girl_rails'
  FactoryGirl.reload
end

