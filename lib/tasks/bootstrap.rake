namespace :bootstrap do
  require 'active_record'
  require 'active_record/fixtures'
  
  desc "load all"
  task :all => ["bootstrap:institutions", "bootstrap:users", "bootstrap:colleges", "bootstrap:master_scenarios", "bootstrap:system_variables"]
  
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
  
  desc "load default master scenarios"
  task :master_scenarios => :environment do
    MasterScenario.delete_all
    Scenario.delete_all
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
      sys_vars = []
      @system_variables.values.each do |sv|
        sv["type_code"] = SystemVariable::TYPES[sv["io_type"].downcase.to_sym] if sv["io_type"]
        sv.delete("io_type")
        sys_vars << sv
      end
      ms.system_variables = system_variables
    end
  end
  
end