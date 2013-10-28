source 'http://rubygems.org'
ruby '2.0.0'
gem 'rails', '3.2.15'
gem 'mysql2'
gem 'locomotive_cms', :require => 'locomotive/engine', github: "locomotivecms/engine"
gem 'custom_fields', github: "ulitiy/custom_fields"
group :assets do
  gem 'sass-rails', ">= 3.2.5"
  gem 'coffee-rails', ">= 3.2.2"
  gem 'uglifier', '>= 1.2.7'
  gem 'haml_coffee_assets'
  gem 'execjs'
  gem 'compass-rails'
  # gem 'turbo-sprockets-rails3'
  gem 'mousetrap-rails'
  gem "therubyracer"
  gem "less-rails", '2.3.3'
  gem 'twitter-bootstrap-rails', '2.2.6'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'rails-backbone', :require=> "backbone-rails" #, github: "codebrew/backbone-rails"
  gem 'bootstrap-wysihtml5-rails'
end

gem 'libv8', '~> 3.11.8'
gem 'sprockets', '>= 2.0'
gem "mongoid"
gem 'delayed_job_mongoid'
gem 'daemons' #dj
# gem "delayed_job_web", git: "https://github.com/izzm/delayed_job_web.git"
gem 'devise'
gem 'cancan'
gem 'russian'
gem 'inherited_resources'
gem 'has_scope'
gem 'haml'
gem 'haml-rails'
gem 'enumerize'
gem 'rack-contrib', require: 'rack/contrib'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'simple_form'
gem "rmagick"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

gem 'i18n-js', github: "fnando/i18n-js"
gem 'jbuilder'
gem "rspec-rails", :group=> [:test, :development]
gem 'yard'
gem 'whenever', :require => false
gem 'routing-filter'

gem 'shikashi'
gem 'sanitize'
gem "airbrake"

group :development do
  gem 'capistrano'
  gem 'capistrano-unicorn'
  gem 'quiet_assets'
  gem 'thin'
  gem 'pry-rails'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request'
end
group :test do
  gem "zeus"
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  gem 'database_cleaner'
  gem 'rb-fsevent'
  gem "selenium-webdriver"
  gem "poltergeist"
  gem "launchy"
  gem 'turn', :require=> false
end
group :production do
  gem 'unicorn-worker-killer'
  gem 'unicorn'
end
