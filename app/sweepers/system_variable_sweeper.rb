class SystemVariableSweeper < ActionController::Caching::Sweeper
  observe SystemVariable

  def after_save(variable)
    expire_action(admins_master_scenario_system_variables_path(variable.master_scenario))
  end

  def after_destroy(variable)
    expire_action(admins_master_scenario_system_variables_path(variable.master_scenario))
  end

end
