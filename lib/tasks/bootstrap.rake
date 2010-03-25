namespace :bootstrap do
  require 'active_record'
  require 'active_record/fixtures'
  
  desc "load all"
  task :all => ["bootstrap:institutions", "bootstrap:users", "bootstrap:colleges"]
  
  desc "load default institutions"
  task :institutions => :environment do
    Fixtures.create_fixtures('db/bootstrap', 'institutions')
  end
  
  desc "load default users"
  task :users => :environment do
    Fixtures.create_fixtures('db/bootstrap', 'users')
  end
  
  desc "load default colleges"
  task :colleges => :environment do
    Fixtures.create_fixtures('db/bootstrap', 'colleges')
  end
end