class MasterScenarioSweeper < ActionController::Caching::Sweeper
  
  observe MasterScenario
  
  def after_save(master_scenario)
    expire_cache(master_scenario)
  end
  
  def after_destroy(master_scenario)
    expire_cache(master_scenario)
  end
  
  private
  
    def expire_cache(master_scenario)
      expire_action(admins_master_scenarios_path)
      expire_action(admins_master_scenario_path(master_scenario))
    end
  
end