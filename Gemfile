source 'http://rubygems.org'
gem 'rails', '3.2.12'
gem 'mysql2'
group :assets do
  gem 'sass-rails', ">= 3.2.5"
  gem 'coffee-rails', ">= 3.2.2"
  gem 'uglifier', '>= 1.2.7'
  gem 'haml_coffee_assets'
  gem 'execjs'
  gem 'compass-rails'
  gem 'turbo-sprockets-rails3'
  gem 'mousetrap-rails'
  gem "therubyracer"
  gem "less-rails"
  gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'rails-backbone', :require=> "backbone-rails" #, github: "codebrew/backbone-rails"
end

gem 'libv8', '~> 3.11.8'
gem 'sprockets', '>= 2.0'
gem "mongoid"
gem 'delayed_job_mongoid'
gem 'daemons' #dj
gem "delayed_job_web", git: "https://github.com/izzm/delayed_job_web.git"
gem 'devise'
gem 'cancan'
gem 'russian'
gem 'inherited_resources'
gem 'has_scope'
gem 'haml'
gem 'haml-rails'

gem 'refinerycms-dashboard', '~> 2.0.0'
gem 'refinerycms-images', '~> 2.0.0'
gem 'refinerycms-pages', '~> 2.0.0'
gem 'refinerycms-resources', '~> 2.0.0'
gem 'refinerycms-i18n', '~> 2.0.0'
gem "refinerycms-news", '~> 2.0.0'
gem 'refinerycms-inquiries', '~> 2.0.0'
gem 'refinerycms-copywriting'

gem 'i18n-js', github: "fnando/i18n-js"
gem 'jbuilder'
gem "rspec-rails", :group=> [:test, :development]
gem 'yard'
gem 'whenever', :require => false

gem 'shikashi'

group :development do
  gem 'capistrano', :github => 'capistrano/capistrano'
  gem 'capistrano-unicorn'
  gem 'quiet_assets'
  gem 'thin'
  gem 'pry-rails'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request'
end
group :test do
  gem "factory_girl_rails"
  gem "capybara"#, '~> 1.1.0'
  gem "guard-rspec"#, '~> 0.7.3'
  gem "growl"
  gem 'database_cleaner'
  gem 'spork'
  gem 'guard-spork'
  gem 'rb-fsevent'#, '~> 0.9.1'
  gem "selenium-webdriver"
  gem "poltergeist"
  gem 'turn', :require=> false
end
group :production do
  gem 'unicorn-worker-killer'
  gem 'unicorn'
end
