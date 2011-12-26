source 'http://rubygems.org'
gem 'rails', '3.1.1'
gem "mysql2"
gem "haml"
gem "compass"
gem "fancy-buttons"
gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'
gem "will_paginate", "~> 3.0.2"
gem 'acts-as-taggable-on'
gem "addressable"
gem "builder"
gem "jammit"
gem "compass"
gem "capistrano"
gem "exception_notification", :git => "http://github.com/rails/exception_notification.git", :require => 'exception_notifier'
gem "wice_grid", '3.0.0.pre1'
gem 'jquery-rails'

group :production do
  gem 'therubyracer'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem "rspec-rails", "~> 2.7.0"
  gem "shoulda-matchers"
  gem "factory_girl_rails", "1.0.1"
  gem "ZenTest"
  gem "autotest-rails"
  gem 'database_cleaner'
end

group :development, :development_cached do
  gem "hirb"
end

group :development, :test do
  gem 'pry', '0.9.8pre2'
end
