namespace :bootstrap do
  require 'active_record'
  require 'active_record/fixtures'
  
  desc "load all"
  task :all => ["bootstrap:institutions", 
                "bootstrap:users", 
                "bootstrap:regions", 
                "bootstrap:colleges", 
                "bootstrap:client_versions", 
                "bootstrap:master_scenarios", 
                "bootstrap:system_variables", 
                "bootstrap:scenarios", 
                "bootstrap:groups", 
                "bootstrap:group_scenarios", 
                "bootstrap:memberships"]
  
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
  
  desc "load regions"
  task :regions => :environment do
    Fixtures.create_fixtures('db/bootstrap', 'regions')
  end
  
  desc "load group scenarios"
  task :group_scenarios => :environment do
    Fixtures.create_fixtures('db/bootstrap', 'group_scenarios')
  end
  
  desc "memberships"
  task :memberships => :environment do
    Fixtures.create_fixtures('db/bootstrap', 'memberships')
  end
  
  desc "load default master scenarios"
  task :master_scenarios => :environment do
    MasterScenario.delete_all
    File.open(File.join(Rails.root, 'db/bootstrap/master_scenarios.yml'), 'r') do |f|
      @master_scenarios = YAML.load(f)
    end
    @master_scenarios.values.each { |ms_atts| MasterScenario.create(ms_atts) }
  end
  
  desc "load default system variables for master scenarios"
  task :system_variables => :environment do
    File.open(File.join(Rails.root, 'db/bootstrap/system_variables.yml'), 'r') do |f|
      @system_variables = YAML.load(f)
    end
    MasterScenario.all.each do |ms|
      @system_variables.values.each { |sv| ms.system_variables.create(sv) }
    end
  end
  
  # desc "load a default version_note for each master_scenario and then resets the versions"
  # task :version_notes => :environment do
  #   MasterScenario.all.each do |ms|
  #     ms.update_attributes(:versions => [], :version => 2)
  #     ms.create_version_note(:master_scenario_version => ms.version, :description => "#{ms.name} has been created.")
  #   end
  # end
  
  desc "Load instructor scenarios for default users"
  task :scenarios => :environment do
    Scenario.delete_all
    File.open(File.join(Rails.root, 'db/bootstrap/scenarios.yml'), 'r') do |f|
      @scenarios = YAML.load(f)
    end
    @scenarios.values.each {|scene_atts| Scenario.create(scene_atts)  }
  end
  
  task :groups => :environment do
    Group.destroy_all # needed to destroy dependent records.
    Fixtures.create_fixtures('db/bootstrap', 'groups')
  end
  
  task :client_versions => :environment do
    ClientVersion.delete_all
    Fixtures.create_fixtures('db/bootstrap', 'client_versions')
  end
  
end