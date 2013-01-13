source 'http://rubygems.org'
gem 'rails', '3.2.11'
group :assets do
  gem 'sass-rails', ">= 3.2.5"
  gem 'coffee-rails', ">= 3.2.2"
  gem 'uglifier', '>= 1.2.7'
  gem 'haml_coffee_assets'
  gem 'execjs'
  gem 'compass-rails'
  gem 'turbo-sprockets-rails3'
end
gem 'libv8', '~> 3.11.8'
gem 'sprockets', '>= 2.0'
gem "mongoid", git: 'https://github.com/mongoid/mongoid.git' #timestamps with milliseconds
gem 'delayed_job_mongoid'
# gem 'dj_mon'
gem "delayed_job_web", git: "https://github.com/izzm/delayed_job_web.git"
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
gem 'markitup-rails'

gem 'i18n-js'
gem 'jbuilder'
gem "rspec-rails", :group=> [:test, :development]
gem 'yard'
gem 'whenever', :require => false
gem "metric_fu"
group :development do
  gem 'capistrano', :github => 'capistrano/capistrano'
  gem 'capistrano-unicorn'
  gem 'pry-rails'
end
group :test do
  gem "factory_girl_rails"
  gem "capybara", '~> 1.1.0'
  gem "guard-rspec", '~> 0.7.3'
  gem "growl"
  gem 'database_cleaner'
  gem 'spork'
  gem 'guard-spork'
  gem 'rb-fsevent', '~> 0.9.1'
  gem "selenium-webdriver"
  #gem "capybara-webkit", git: "https://github.com/thoughtbot/capybara-webkit.git"
  gem "poltergeist"
  gem 'turn', :require=> false
end
group :production do
  gem 'unicorn'
end
