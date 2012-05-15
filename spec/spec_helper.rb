require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'simplecov'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Devise.stretches = 1
  Rails.logger.level = 4

  SimpleCov.start 'rails'

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run :focus
  end
end

Spork.each_run do
  require 'factory_girl_rails'
  FactoryGirl.reload
end

