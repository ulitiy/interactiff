  module Kernel
    alias :__at_exit :at_exit
    def at_exit(&block)
      __at_exit do
        exit_status = $!.status if $!.is_a?(SystemExit)
        block.call
        exit exit_status if exit_status
      end
    end
  end

require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require "capybara/rspec"
  include Capybara::DSL

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = false #false!!! см ниже
    config.include(ControllerMacros)
    config.include(IntegrationMacros)
    #если использовать транзакционную очистку с js, то придёт звизда
    config.before :each do
      if Capybara.current_driver == :rack_test
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
      DatabaseCleaner.start
    end
    config.before(:each, :type=>:request) { create_domain }
    config.after(:each, :type=>:request) { destroy_domain }
    config.after do
      DatabaseCleaner.clean
    end

  end

  Capybara.configure do |config|
    config.app_host   = 'http://requests.lvh.me:54163'
    config.server_port = '54163'
  end

  Selenium::WebDriver::Firefox.path = "/Applications/Firefox.app/Contents/MacOS/firefox-bin-selenium"

  def t param
    I18n.t param
  end
end

Spork.each_run do
  FactoryGirl.reload
  `killall firefox-bin-selenium`
end

