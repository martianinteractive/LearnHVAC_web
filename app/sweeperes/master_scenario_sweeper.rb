class MasterScenarioSweeper < ActionController::Caching::Sweeper
  
  observe MasterScenario
  
  def after_save(master_scenario)
    expire_action(admins_master_scenarios_path)
  end
  
  def after_destroy(master_scenario)
    expire_action(admins_master_scenarios_path)
  end
  
end