source 'http://rubygems.org'
gem 'rails', "3.1.1"
gem 'sprockets', '~> 2.0'
gem "mysql2"
gem 'devise', git: "https://github.com/plataformatec/devise.git"
gem 'russian', git: "https://github.com/yaroslav/russian.git"
#gem 'inherited_resources', git: 'https://github.com/zerobearing2/inherited_resources.git'
#gem 'has_scope', git: "https://github.com/plataformatec/has_scope.git"
gem 'haml'
gem 'haml-rails'
#gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git'
#gem 'nested_form', git: 'https://github.com/ryanb/nested_form.git'
group :assets do
  gem 'sass-rails', "  ~> 3.1.1"
  gem 'coffee-rails', "~> 3.1.1"
  gem 'uglifier'
end
gem 'jquery-rails'
gem 'citier'
gem 'rails_sql_views', git: 'https://github.com/morgz/rails_sql_views.git'
#gem 'carrierwave'
#gem 'sprockets', git: "https://github.com/sstephenson/sprockets.git" #с этим гемом постоянно проблемы пока...
#gem 'sproutcore-rails', git: 'git://github.com/ebastien/sproutcore-rails.git'
group :production do
  gem 'unicorn'
end
gem 'capistrano'
#gem 'sproutcore'
gem 'bulk_api', git: 'https://github.com/drogus/bulk_api.git', branch: "sc1" #очень важный и крутой гем, нужно его использовать для взаимодействия со спраутом. Общался с разработчиком Петром Дрогусом, см. почту.
gem "rspec-rails", group: [:test, :development]#, git: 'https://github.com/rspec/rspec-rails.git'
group :test do
  gem "factory_girl_rails"
  gem "capybara", git:  'https://github.com/jnicklas/capybara.git'
  gem "selenium-webdriver", "~> 2.5.0"
#  gem 'guard'
#  gem 'rb-readline'
  gem "guard-rspec"#, git: 'https://github.com/guard/guard-rspec.git'
  gem "growl_notify"
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'spork'#, git: 'https://github.com/timcharper/spork.git'
  gem 'guard-spork'#, git: 'https://github.com/guard/guard-spork.git'

  # gem 'ruby-debug-base19', "0.11.24"
  # gem 'ruby-debug19', :require => 'ruby-debug'

    # Pretty printed test output
  gem 'turn', require: false
end
