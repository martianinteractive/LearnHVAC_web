source "http://gemcutter.org"
gem "rails", "3.0.0.beta"
gem "haml"
gem "compass", "0.10.0.rc1"
gem "mysql"
gem "will_paginate", "3.0.pre"
gem "mongo", "0.19.1"
gem "mongo_ext", "0.19.1"
gem "mongoid", :git => "git://github.com/durran/mongoid.git", "2.0.0.beta1" if RUBY_VERSION == "1.8.7"

group :test do
  gem "rspec-rails", ">= 2.0.0.beta.1"
  # gem "shoulda", :git => "git://github.com/thoughtbot/shoulda.git", :branch => "rails3"
  gem "factory_girl", :git => "git://github.com/thoughtbot/factory_girl.git", :branch => "rails3"
  gem "mocha"
end

group :development do
  gem "ruby-debug" if RUBY_VERSION == "1.8.7"
  gem "ruby-debug19" if RUBY_VERSION == "1.9.1"
  gem "hirb"
end
