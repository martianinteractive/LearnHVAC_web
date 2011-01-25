class MembershipSweeper < ActionController::Caching::Sweeper
  
  observe Membership
  
  def after_save(membership)
    expire_action(admins_scenario_accesses_path(membership.scenario))
  end
  
  def after_destroy(membership)
    expire_action(admins_scenario_accesses_path(membership.scenario))
  end
  
end
