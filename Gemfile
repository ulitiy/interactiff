source 'http://rubygems.org'
gem 'rails', '3.2.8'
group :assets do
  gem 'sass-rails', ">= 3.2.5"
  gem 'coffee-rails', ">= 3.2.2"
  gem 'uglifier', '>= 1.2.7'
  gem 'haml_coffee_assets'
  gem 'execjs'
  gem 'compass-rails'
end
gem 'sprockets', '>= 2.0'
gem "mongoid", ">= 3.0.3" #timestamps with milliseconds
gem 'delayed_job_mongoid'
gem 'dj_mon'
gem "daemons"
gem 'devise'#, :git=> "https://github.com/plataformatec/devise.git"
gem 'cancan'
gem 'russian', :git=> "https://github.com/yaroslav/russian.git"
gem 'inherited_resources'#, :git=> 'https://github.com/zerobearing2/inherited_resources.git'
gem 'has_scope'#, :git=> "https://github.com/plataformatec/has_scope.git"
gem 'haml'
gem 'haml-rails'

gem 'mousetrap-rails'
gem "therubyracer"
gem "less-rails"
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'rails-backbone', :git=> "git://github.com/codebrew/backbone-rails.git", :require=> "backbone-rails"

gem 'i18n-js'
gem 'jbuilder'
gem "rspec-rails", :group=> [:test, :development]
gem 'yard'
gem 'whenever', :require => false
group :development do
  gem 'capistrano'
  gem 'capistrano-unicorn'
end
group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec", '~> 0.7.3'
  gem "growl"
  gem 'database_cleaner'
  gem 'spork'
  gem 'guard-spork'
  gem 'rb-fsevent', '~> 0.9.1'
  gem "selenium-webdriver"
  gem "capybara-webkit" #https://github.com/thoughtbot/capybara-webkit/issues/296
  gem 'turn', :require=> false
end
group :production do
  gem 'unicorn'
end
