class InstitutionSweeper < ActionController::Caching::Sweeper
  observe Institution

  def after_save(institution)
    expire_cache(institution)
  end

  def after_destroy(institution)
    expire_cache(institution)
  end

  private

  def expire_cache(institution)
    expire_users(institution)
  end
  
  # PENDING: TO CALL THIS WITH DELAYED JOB!!
  def expire_users(institution)
    institution.users.each do |user| 
      expire_action(admins_users_path(:role => user.role))
      
      user.all_scenarios.each do |scenario|
        expire_action(admins_scenario_accesses_path(scenario))
      end
    end
  end

end