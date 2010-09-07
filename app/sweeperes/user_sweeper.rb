class UserSweeper < ActionController::Caching::Sweeper
  
  observe User
  
  def after_save(user)
    expire_user_actions(user)
    expire_scenarios(user.all_scenarios)
  end
  
  def after_destroy(user)
    expire_user_actions(user)
    expire_scenarios(user.all_scenarios)
  end
  
  private
  
  def expire_user_actions(user)
    expire_action("profile/#{user.login}")
    expire_action(admins_users_path(:role => user.role))
  end
  
  def expire_scenarios(scenarios)
    scenarios.each do |scenario|
      expire_action(admins_scenario_accesses_path(scenario))
    end
  end
  
end
