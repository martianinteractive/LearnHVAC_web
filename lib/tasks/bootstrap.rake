namespace :bootstrap do
  require 'active_record'
  require 'active_record/fixtures'

  desc "load default users"
  task :users => :environment do
    Fixtures.create_fixtures('db/bootstrap', 'users')
  end
  
  desc "load default colleges"
  task :colleges => :environment do
    Fixtures.create_fixtures('db/bootstrap', 'colleges')
  end
end