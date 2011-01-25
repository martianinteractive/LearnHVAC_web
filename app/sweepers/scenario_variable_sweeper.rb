class ScenarioVariableSweeper < ActionController::Caching::Sweeper
  
  observe ScenarioVariable
  
  def after_save(variable)
    expire_action(admins_scenario_variables_path(variable.scenario))
  end
  
  def after_destroy(variable)
    expire_action(admins_scenario_variables_path(variable.scenario))
  end
  
end
