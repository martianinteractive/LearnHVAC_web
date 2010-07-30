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
                "bootstrap:memberships",
                "bootstrap:class_notification_emails",
                "bootstrap:tags"]
  
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
    Fixtures.create_fixtures('db/bootstrap', 'master_scenarios')
  end
  
  desc "load default system variables for master scenarios"
  task :system_variables => :environment do
    File.open(File.join(Rails.root, 'db/bootstrap/system_variables.yml'), 'r') do |f|
      @system_variables = YAML.load(f)
    end
    MasterScenario.all.each do |ms|
      @system_variables.values.each { |sv| ms.variables.create(sv) }
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
  
  task :class_notification_emails => :environment do 
    ClassNotificationEmail.delete_all
  end
  
  task :tags => :environment do
    Tag.delete_all
    Tagging.delete_all
  end
  
  namespace :fixtures do
    desc 'Create YAML fixtures from data in an existing database.  
    Defaults to development database.  Set RAILS_ENV to override.'
    task :dump => :environment do
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info"]
      ActiveRecord::Base.establish_connection(Rails.env)
      tables=ENV['TABLES'].split(',')
      tables ||= (ActiveRecord::Base.connection.tables - skip_tables)

      tables.each do |table_name|
        i = "000"
        File.open("#{RAILS_ROOT}/db/bootstrap/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end
  end
  
end
