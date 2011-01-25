class GroupSweeper < ActionController::Caching::Sweeper
  observe Group

  def after_save(group)
    expire_scenarios(group.scenarios)
  end

  def after_destroy(group)
    expire_scenarios(group.scenarios)
  end
  
  private
  
  def expire_scenarios(scenarios)
    scenarios.each do |scenario|
      expire_action(admins_scenario_accesses_path(scenario))
    end
  end

end
