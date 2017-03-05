ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'
require 'database_cleaner'
require 'email_spec'
require 'simplecov'
require 'capybara/rails'
require 'capybara/rspec'
require 'shoulda/matchers'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Devise.stretches = 1
Rails.logger.level = 4

SimpleCov.start 'rails'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include Support::BuildHelper
  config.include Support::ControllerHelper
  config.include Support::DelayedJobHelper

  config.before(:example) do
    DatabaseCleaner.start
  end

  config.after(:example) do
    DatabaseCleaner.clean
  end

  config.before do
    allow_any_instance_of(Repository).to receive(:sync_github)
    allow_any_instance_of(Repository).to receive(:setup_github_hook)
    allow(Devise).to receive(:friendly_token).and_return('123456789')
  end

  config.expose_dsl_globally = false
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :rails
  end
end
