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

  require 'rails/mongoid'
  Spork.trap_class_method(Rails::Mongoid, :load_models)
  require 'factory_girl_rails'
  Spork.trap_class_method(FactoryGirl, :find_definitions)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require "capybara/rspec"
  include Capybara::DSL

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    #config.use_transactional_fixtures = false
    config.include Devise::TestHelpers, :type => :controller
    config.include FactoryGirl::Syntax::Methods
    config.include ControllerMacros
    config.include IntegrationMacros
    config.before :each do
      DatabaseCleaner[:mongoid].strategy = :truncation
      DatabaseCleaner.start
    end
    config.before(:each, :type=>:request) { create_domain }
    config.after(:each, :type=>:request) { destroy_domain }
    config.after { DatabaseCleaner.clean }

  end

  Capybara.configure do |config|
    config.app_host   = 'http://requests.lvh.me:54163'
    config.server_port = '54163'
    config.javascript_driver = :webkit #comment to see in Firefox
  end

  def t param
    I18n.t param
  end

  def login(user)
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: 'secret'
    click_button 'Sign in'
  end

end

Spork.each_run do
  # silence_warnings do #reload models
  #   Dir["#{Rails.root}/app/models/**/*.rb"].each {|f| load f}
  # end
  FactoryGirl.reload
end
