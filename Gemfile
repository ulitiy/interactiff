source 'http://rubygems.org'
gem 'rails', '3.2.1'
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'haml_coffee_assets'
  gem 'execjs'
end
gem 'sprockets', '~> 2.0'
gem "mongoid", "~> 2.4"
gem "bson_ext", "~> 1.5"
gem 'devise', :git=> "https://github.com/plataformatec/devise.git"
gem 'cancan'
gem 'russian', :git=> "https://github.com/yaroslav/russian.git"
gem 'inherited_resources', :git=> 'https://github.com/zerobearing2/inherited_resources.git'
gem 'has_scope', :git=> "https://github.com/plataformatec/has_scope.git"
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'rails-backbone', :git=> "git://github.com/codebrew/backbone-rails.git", :require=> "backbone-rails"
gem 'i18n-js'
gem 'jbuilder'
gem 'capistrano'
gem "rspec-rails", :group=> [:test, :development]
gem 'yard'
group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  gem "growl"
  gem 'database_cleaner'
  gem 'spork'
  gem 'guard-spork'
  gem "selenium-webdriver"
  gem "capybara-webkit" #https://github.com/thoughtbot/capybara-webkit/issues/296
  gem 'turn', :require=> false
end
group :production do
  gem 'unicorn'
end
