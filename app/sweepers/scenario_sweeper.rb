class ScenarioSweeper < ActionController::Caching::Sweeper
  
  observe Scenario 
  
  def after_save(scenario)
    expire_action(admins_scenarios_path)
  end
  
  def after_destroy(scenario)
    expire_action(admins_scenarios_path)
  end
  
end