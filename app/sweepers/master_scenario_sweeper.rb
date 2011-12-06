class MasterScenarioSweeper < ActionController::Caching::Sweeper

  observe MasterScenario

  def after_save(master_scenario)
    expire_cache_for(master_scenario)
  end

  def after_destroy(master_scenario)
    expire_cache_for(master_scenario)
  end

  private

  def expire_cache_for(master_scenario)
    # Expire master_scenarios#index
    options = { :controller => "admins/master_scenarios", :action => 'index' }
    expire_page(options)

    # Expire master_scenarios#show
    options.merge! :action => 'show', :id => master_scenario.id
    expire_page(options)
  end

end
