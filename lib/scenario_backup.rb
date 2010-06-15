class ScenarioBackup
  def self.for(scenario_id)
    backup = self.new(scenario_id)
    backup.create!
  end
  
  def initialize(scenario_id)
    @scenario = MasterScenario.find(scenario_id)
    @backup_folder = Rails.root + "db/backup"
    @backup_file = @backup_folder + "/backup.yml"
  end
  
  def create!
    # delete_and_create_backup_dir!
    # File.open(@backup_file, "w") do |f|
    #   f.write(@scenario.to_yaml)
    # end
  end
  
  def delete_and_create_backup_dir!
    FileUtils.rm_rf @backup_folder
    FileUtils.mkdir @backup_folder
    FileUtils.touch @backup_file
  end
    
end